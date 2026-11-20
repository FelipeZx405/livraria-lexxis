package br.com.lexxis.dao;

import br.com.lexxis.model.ItemPedido;
import br.com.lexxis.model.Pedido;
import br.com.lexxis.servlet.config.ConnectionPoolConfig;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PedidoDao {

    private static final String COLUNAS = "ID, USUARIO_ID, DATA_PEDIDO, VALOR_SUBTOTAL, VALOR_FRETE, VALOR_DESCONTO, "
            + "VALOR_TOTAL, FORMA_PAGAMENTO, PARCELAS, CARTAO_FINAL, SITUACAO, DEST_NOME, CEP, ENDERECO, NUMERO, "
            + "COMPLEMENTO, BAIRRO, CIDADE, UF";

    // Cria o pedido numa transação: baixa o estoque, grava o pedido e os itens.
    // Se algo falhar, desfaz tudo. Lança IllegalStateException com a mensagem para o cliente.
    public int criarPedido(Pedido pedido) {

        Connection connection = null;

        try {

            connection = ConnectionPoolConfig.getConnection();
            connection.setAutoCommit(false);

            baixarEstoque(connection, pedido);
            int pedidoId = inserirPedido(connection, pedido);
            inserirItens(connection, pedidoId, pedido);

            connection.commit();

            System.out.println("Pedido criado: " + pedidoId);

            return pedidoId;

        } catch (IllegalStateException e) {

            desfazer(connection);
            throw e;

        } catch (Exception e) {

            desfazer(connection);
            System.out.println("Falha ao criar o pedido: " + e.getMessage());
            throw new IllegalStateException("Não foi possível registrar o pedido. Tente novamente.");

        } finally {

            fechar(connection);
        }
    }

    private void baixarEstoque(Connection connection, Pedido pedido) throws SQLException {

        String SQL = "UPDATE LIVRO SET ESTOQUE = ESTOQUE - ? WHERE ID = ? AND ESTOQUE >= ?";

        try (PreparedStatement ps = connection.prepareStatement(SQL)) {

            for (ItemPedido item : pedido.getItens()) {

                ps.setInt(1, item.getQuantidade());
                ps.setInt(2, Integer.parseInt(item.getLivroId()));
                ps.setInt(3, item.getQuantidade());

                if (ps.executeUpdate() == 0) {
                    throw new IllegalStateException("Estoque insuficiente para \"" + item.getNome()
                            + "\". Revise o seu carrinho.");
                }
            }
        }
    }

    private int inserirPedido(Connection connection, Pedido p) throws SQLException {

        String SQL = "INSERT INTO PEDIDO (USUARIO_ID, VALOR_SUBTOTAL, VALOR_FRETE, VALOR_DESCONTO, VALOR_TOTAL, "
                + "FORMA_PAGAMENTO, PARCELAS, CARTAO_FINAL, SITUACAO, DEST_NOME, CEP, ENDERECO, NUMERO, "
                + "COMPLEMENTO, BAIRRO, CIDADE, UF) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(SQL, new String[]{"ID"})) {

            ps.setInt(1, p.getUsuarioId());
            ps.setDouble(2, p.getSubtotal());
            ps.setDouble(3, p.getFrete());
            ps.setDouble(4, p.getDesconto());
            ps.setDouble(5, p.getTotal());
            ps.setString(6, p.getFormaPagamento());
            ps.setInt(7, p.getParcelas());
            ps.setString(8, p.getCartaoFinal());
            ps.setString(9, p.getSituacao());
            ps.setString(10, p.getDestNome());
            ps.setString(11, p.getCep());
            ps.setString(12, p.getEndereco());
            ps.setString(13, p.getNumero());
            ps.setString(14, p.getComplemento());
            ps.setString(15, p.getBairro());
            ps.setString(16, p.getCidade());
            ps.setString(17, p.getUf());
            ps.executeUpdate();

            try (ResultSet chaves = ps.getGeneratedKeys()) {
                if (chaves.next()) {
                    return chaves.getInt(1);
                }
            }
        }

        throw new SQLException("Pedido sem id gerado");
    }

    private void inserirItens(Connection connection, int pedidoId, Pedido pedido) throws SQLException {

        String SQL = "INSERT INTO ITEM_PEDIDO (PEDIDO_ID, LIVRO_ID, NOME, AUTOR, PRECO, QUANTIDADE) VALUES (?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = connection.prepareStatement(SQL)) {

            for (ItemPedido item : pedido.getItens()) {
                ps.setInt(1, pedidoId);
                ps.setInt(2, Integer.parseInt(item.getLivroId()));
                ps.setString(3, item.getNome());
                ps.setString(4, item.getAutor());
                ps.setDouble(5, item.getPreco());
                ps.setInt(6, item.getQuantidade());
                ps.executeUpdate();
            }
        }
    }

    // devolve null se não achar
    public Pedido findById(int id) {

        String SQL = "SELECT " + COLUNAS + " FROM PEDIDO WHERE ID = ?";

        try (Connection connection = ConnectionPoolConfig.getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL)) {

            ps.setInt(1, id);

            Pedido pedido = null;

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    pedido = mapear(rs);
                }
            }

            if (pedido != null) {
                pedido.setItens(carregarItens(connection, pedido.getId()));
            }

            return pedido;

        } catch (Exception e) {

            System.out.println("Erro ao buscar o pedido: " + e.getMessage());
            return null;
        }
    }

    // pedidos de um usuário, do mais novo para o mais antigo
    public List<Pedido> findByUsuario(int usuarioId) {

        String SQL = "SELECT " + COLUNAS + " FROM PEDIDO WHERE USUARIO_ID = ? ORDER BY ID DESC";

        List<Pedido> pedidos = new ArrayList<Pedido>();

        try (Connection connection = ConnectionPoolConfig.getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL)) {

            ps.setInt(1, usuarioId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    pedidos.add(mapear(rs));
                }
            }

            for (Pedido pedido : pedidos) {
                pedido.setItens(carregarItens(connection, pedido.getId()));
            }

        } catch (Exception e) {

            System.out.println("Erro ao listar os pedidos: " + e.getMessage());
        }

        return pedidos;
    }

    // simula a confirmação do pagamento (Pix/boleto). Só vale para pedidos aguardando pagamento
    public boolean marcarComoPago(int pedidoId, int usuarioId) {

        String SQL = "UPDATE PEDIDO SET SITUACAO = 'PAGO' "
                + "WHERE ID = ? AND USUARIO_ID = ? AND SITUACAO = 'AGUARDANDO_PAGAMENTO'";

        try (Connection connection = ConnectionPoolConfig.getConnection();
             PreparedStatement ps = connection.prepareStatement(SQL)) {

            ps.setInt(1, pedidoId);
            ps.setInt(2, usuarioId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {

            System.out.println("Erro ao confirmar o pagamento: " + e.getMessage());
            return false;
        }
    }

    // cancela um pedido que ainda aguarda pagamento e devolve os livros ao estoque
    public boolean cancelar(int pedidoId, int usuarioId) {

        Connection connection = null;

        try {

            connection = ConnectionPoolConfig.getConnection();
            connection.setAutoCommit(false);

            String SQL = "UPDATE PEDIDO SET SITUACAO = 'CANCELADO' "
                    + "WHERE ID = ? AND USUARIO_ID = ? AND SITUACAO = 'AGUARDANDO_PAGAMENTO'";

            int alterados;

            try (PreparedStatement ps = connection.prepareStatement(SQL)) {
                ps.setInt(1, pedidoId);
                ps.setInt(2, usuarioId);
                alterados = ps.executeUpdate();
            }

            if (alterados == 0) {
                desfazer(connection);
                return false;
            }

            List<ItemPedido> itens = carregarItens(connection, pedidoId);

            try (PreparedStatement ps = connection.prepareStatement(
                    "UPDATE LIVRO SET ESTOQUE = ESTOQUE + ? WHERE ID = ?")) {

                for (ItemPedido item : itens) {
                    ps.setInt(1, item.getQuantidade());
                    ps.setInt(2, Integer.parseInt(item.getLivroId()));
                    ps.executeUpdate();
                }
            }

            connection.commit();
            return true;

        } catch (Exception e) {

            desfazer(connection);
            System.out.println("Erro ao cancelar o pedido: " + e.getMessage());
            return false;

        } finally {

            fechar(connection);
        }
    }

    private List<ItemPedido> carregarItens(Connection connection, int pedidoId) throws SQLException {

        String SQL = "SELECT LIVRO_ID, NOME, AUTOR, PRECO, QUANTIDADE FROM ITEM_PEDIDO WHERE PEDIDO_ID = ? ORDER BY ID";

        List<ItemPedido> itens = new ArrayList<ItemPedido>();

        try (PreparedStatement ps = connection.prepareStatement(SQL)) {

            ps.setInt(1, pedidoId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    itens.add(new ItemPedido(
                            rs.getString("LIVRO_ID"),
                            rs.getString("NOME"),
                            rs.getString("AUTOR"),
                            rs.getDouble("PRECO"),
                            rs.getInt("QUANTIDADE")));
                }
            }
        }

        return itens;
    }

    private Pedido mapear(ResultSet rs) throws SQLException {

        Pedido p = new Pedido();
        p.setId(rs.getInt("ID"));
        p.setUsuarioId(rs.getInt("USUARIO_ID"));
        p.setData(rs.getTimestamp("DATA_PEDIDO"));
        p.setSubtotal(rs.getDouble("VALOR_SUBTOTAL"));
        p.setFrete(rs.getDouble("VALOR_FRETE"));
        p.setDesconto(rs.getDouble("VALOR_DESCONTO"));
        p.setTotal(rs.getDouble("VALOR_TOTAL"));
        p.setFormaPagamento(rs.getString("FORMA_PAGAMENTO"));
        p.setParcelas(rs.getInt("PARCELAS"));
        p.setCartaoFinal(rs.getString("CARTAO_FINAL"));
        p.setSituacao(rs.getString("SITUACAO"));
        p.setDestNome(rs.getString("DEST_NOME"));
        p.setCep(rs.getString("CEP"));
        p.setEndereco(rs.getString("ENDERECO"));
        p.setNumero(rs.getString("NUMERO"));
        p.setComplemento(rs.getString("COMPLEMENTO"));
        p.setBairro(rs.getString("BAIRRO"));
        p.setCidade(rs.getString("CIDADE"));
        p.setUf(rs.getString("UF"));
        return p;
    }

    private void desfazer(Connection connection) {
        if (connection != null) {
            try {
                connection.rollback();
            } catch (Exception ignorada) {
            }
        }
    }

    private void fechar(Connection connection) {
        if (connection != null) {
            try {
                connection.setAutoCommit(true);
            } catch (Exception ignorada) {
            }
            try {
                connection.close();
            } catch (Exception ignorada) {
            }
        }
    }
}
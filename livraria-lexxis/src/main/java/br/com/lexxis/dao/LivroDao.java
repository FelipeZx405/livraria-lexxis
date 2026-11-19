package br.com.lexxis.dao;

import br.com.lexxis.model.Capa;
import br.com.lexxis.model.Livro;
import br.com.lexxis.servlet.config.ConnectionPoolConfig;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class LivroDao {

    // colunas dos livros SEM a imagem (a imagem é pesada e só é lida pelo findCapa)
    private static final String COLUNAS = "ID, NAME, AUTOR, DESCRICAO, PRECO, ESTOQUE, CATEGORIA, CAPA_TIPO, CAPA_VERSAO";

    // devolve o id do livro criado (ou null se der erro), para depois gravar a capa
    public String createLivro(Livro livro){

        String SQL = "INSERT INTO LIVRO (NAME, AUTOR, DESCRICAO, PRECO, ESTOQUE, CATEGORIA) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection connection = ConnectionPoolConfig.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SQL, new String[]{"ID"})) {

            preparedStatement.setString(1, livro.getNome());
            preparedStatement.setString(2, livro.getAutor());
            preparedStatement.setString(3, livro.getDescricao());
            preparedStatement.setDouble(4, livro.getPreco());
            preparedStatement.setInt(5, livro.getEstoque());
            preparedStatement.setString(6, livro.getCategoria());
            preparedStatement.executeUpdate();

            System.out.println("Sucesso ao inserir o livro");

            try (ResultSet chaves = preparedStatement.getGeneratedKeys()) {
                if (chaves.next()) {
                    return chaves.getString(1);
                }
            }

        } catch (Exception e) {

            System.out.println("Falha ao inserir o livro no banco de dados: " + e.getMessage());

        }

        return null;

    }

    public List<Livro> findAllLivros() {

        String SQL = "SELECT " + COLUNAS + " FROM LIVRO ORDER BY ID";

        try (Connection connection = DriverManager.getConnection("jdbc:h2:~/test", "sa", "sa");
             PreparedStatement preparedStatement = connection.prepareStatement(SQL);
             ResultSet resultSet = preparedStatement.executeQuery()) {

            List<Livro> livros = new ArrayList<>();

            while (resultSet.next()) {
                livros.add(mapear(resultSet));
            }

            System.out.println("Sucesso ao consultar os dados no DB");

            return livros;

        } catch (Exception e) {

            System.out.println("Erro ao consultar os livros no banco de dados" + e.getMessage());

            return Collections.emptyList();
        }
    }

    // busca um livro pelo id (usado para abrir o formulário de edição). Devolve null se não achar
    public Livro findById(String id) {

        String SQL = "SELECT " + COLUNAS + " FROM LIVRO WHERE ID = ?";

        try (Connection connection = DriverManager.getConnection("jdbc:h2:~/test", "sa", "sa");
             PreparedStatement preparedStatement = connection.prepareStatement(SQL)) {

            preparedStatement.setInt(1, Integer.parseInt(id));

            try (ResultSet resultSet = preparedStatement.executeQuery()) {

                if (resultSet.next()) {
                    return mapear(resultSet);
                }
            }

        } catch (Exception e) {

            System.out.println("Erro ao buscar o livro: " + e.getMessage());

        }

        return null;
    }

    public void deleteById(String id) {

        String SQL = "DELETE LIVRO WHERE ID = ?";

        try (Connection connection = DriverManager.getConnection("jdbc:h2:~/test", "sa", "sa");
             PreparedStatement preparedStatement = connection.prepareStatement(SQL)) {

            preparedStatement.setString(1, id);
            preparedStatement.execute();

            System.out.println("sucesso ao deletar o livro com o id: " + id);

        } catch (Exception e) {

            System.out.println("Falha ao conectar com o banco de dados!!!");

        }

    }

    // atualiza os dados do livro. A capa NÃO é mexida aqui (veja atualizarCapa e removerCapa)
    public void updateLivro(Livro livro) {

        String SQL = "UPDATE LIVRO SET NAME = ?, AUTOR = ?, DESCRICAO = ?, PRECO = ?, ESTOQUE = ?, CATEGORIA = ? WHERE ID = ?";

        try (Connection connection = DriverManager.getConnection("jdbc:h2:~/test", "sa", "sa");
             PreparedStatement preparedStatement = connection.prepareStatement(SQL)) {

            preparedStatement.setString(1, livro.getNome());
            preparedStatement.setString(2, livro.getAutor());
            preparedStatement.setString(3, livro.getDescricao());
            preparedStatement.setDouble(4, livro.getPreco());
            preparedStatement.setInt(5, livro.getEstoque());
            preparedStatement.setString(6, livro.getCategoria());
            preparedStatement.setString(7, livro.getId());
            preparedStatement.execute();

            System.out.println("Sucesso ao atualizar o livro");

        } catch (Exception e) {

            System.out.println("Falha ao conectar no Banco de Dados");
            System.out.println("Error: " + e.getMessage());

        }

    }

    // grava (ou troca) a capa do livro
    public void atualizarCapa(String id, byte[] dados, String tipo) {

        String SQL = "UPDATE LIVRO SET CAPA = ?, CAPA_TIPO = ?, CAPA_VERSAO = ? WHERE ID = ?";

        try (Connection connection = DriverManager.getConnection("jdbc:h2:~/test", "sa", "sa");
             PreparedStatement preparedStatement = connection.prepareStatement(SQL)) {

            preparedStatement.setBytes(1, dados);
            preparedStatement.setString(2, tipo);
            preparedStatement.setLong(3, System.currentTimeMillis());
            preparedStatement.setInt(4, Integer.parseInt(id));
            preparedStatement.execute();

            System.out.println("Sucesso ao gravar a capa do livro " + id);

        } catch (Exception e) {

            System.out.println("Falha ao gravar a capa: " + e.getMessage());

        }
    }

    public void removerCapa(String id) {

        String SQL = "UPDATE LIVRO SET CAPA = NULL, CAPA_TIPO = NULL, CAPA_VERSAO = 0 WHERE ID = ?";

        try (Connection connection = DriverManager.getConnection("jdbc:h2:~/test", "sa", "sa");
             PreparedStatement preparedStatement = connection.prepareStatement(SQL)) {

            preparedStatement.setInt(1, Integer.parseInt(id));
            preparedStatement.execute();

            System.out.println("Sucesso ao remover a capa do livro " + id);

        } catch (Exception e) {

            System.out.println("Falha ao remover a capa: " + e.getMessage());

        }
    }

    // lê só a imagem (usado pelo CapaServlet). Devolve null se o livro não tem capa
    public Capa findCapa(String id) {

        String SQL = "SELECT CAPA, CAPA_TIPO FROM LIVRO WHERE ID = ? AND CAPA_TIPO IS NOT NULL";

        try (Connection connection = DriverManager.getConnection("jdbc:h2:~/test", "sa", "sa");
             PreparedStatement preparedStatement = connection.prepareStatement(SQL)) {

            preparedStatement.setInt(1, Integer.parseInt(id));

            try (ResultSet resultSet = preparedStatement.executeQuery()) {

                if (resultSet.next()) {

                    byte[] dados = resultSet.getBytes("CAPA");

                    if (dados != null) {
                        return new Capa(dados, resultSet.getString("CAPA_TIPO"));
                    }
                }
            }

        } catch (Exception e) {

            System.out.println("Erro ao buscar a capa: " + e.getMessage());

        }

        return null;
    }

    private Livro mapear(ResultSet resultSet) throws SQLException {

        Livro livro = new Livro();
        livro.setId(resultSet.getString("ID"));
        livro.setNome(resultSet.getString("NAME"));
        livro.setAutor(resultSet.getString("AUTOR"));
        livro.setDescricao(resultSet.getString("DESCRICAO"));
        livro.setPreco(resultSet.getDouble("PRECO"));
        livro.setEstoque(resultSet.getInt("ESTOQUE"));
        livro.setCategoria(resultSet.getString("CATEGORIA"));
        livro.setTemCapa(resultSet.getString("CAPA_TIPO") != null);
        livro.setCapaVersao(resultSet.getLong("CAPA_VERSAO"));
        return livro;

    }
}
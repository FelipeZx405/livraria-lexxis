package br.com.lexxis.servlet;

import br.com.lexxis.dao.LivroDao;
import br.com.lexxis.dao.PedidoDao;
import br.com.lexxis.model.Carrinho;
import br.com.lexxis.model.ItemCarrinho;
import br.com.lexxis.model.ItemPedido;
import br.com.lexxis.model.Livro;
import br.com.lexxis.model.Pedido;
import br.com.lexxis.model.Usuario;
import br.com.lexxis.util.PedidoUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        Carrinho carrinho = carregarCarrinho(req, resp);

        if (carrinho == null) {
            return;
        }

        prepararTela(req, carrinho);
        req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        Carrinho carrinho = carregarCarrinho(req, resp);

        if (carrinho == null) {
            return;
        }

        Usuario usuario = (Usuario) req.getSession().getAttribute("usuarioLogado");

        String nome = limpar(req.getParameter("nome"));
        String cep = PedidoUtil.soDigitos(req.getParameter("cep"));
        String endereco = limpar(req.getParameter("endereco"));
        String numero = limpar(req.getParameter("numero"));
        String complemento = limpar(req.getParameter("complemento"));
        String bairro = limpar(req.getParameter("bairro"));
        String cidade = limpar(req.getParameter("cidade"));
        String uf = limpar(req.getParameter("uf")).toUpperCase();
        String forma = limpar(req.getParameter("forma"));

        // os valores são SEMPRE recalculados aqui; nada de preço vindo do navegador
        double subtotal = PedidoUtil.arredondar(carrinho.getTotal());
        double frete = PedidoUtil.calcularFrete(subtotal);
        double desconto = PedidoUtil.calcularDesconto(forma, subtotal);
        double total = PedidoUtil.arredondar(subtotal + frete - desconto);

        int parcelas = 1;
        String cartaoFinal = null;
        String erro = null;

        if (nome.isEmpty() || endereco.isEmpty() || numero.isEmpty() || bairro.isEmpty() || cidade.isEmpty()) {

            erro = "Preencha todos os campos obrigatórios do endereço.";

        } else if (nome.length() > 255 || endereco.length() > 255 || numero.length() > 20
                || complemento.length() > 100 || bairro.length() > 100 || cidade.length() > 100) {

            erro = "Algum campo do endereço está grande demais.";

        } else if (cep.length() != 8) {

            erro = "Informe um CEP válido (8 números).";

        } else if (!PedidoUtil.ufValida(uf)) {

            erro = "Selecione o estado (UF).";

        } else if (!Pedido.PIX.equals(forma) && !Pedido.CARTAO.equals(forma) && !Pedido.BOLETO.equals(forma)) {

            erro = "Escolha uma forma de pagamento.";

        } else if (Pedido.CARTAO.equals(forma)) {

            String numeroCartao = PedidoUtil.soDigitos(req.getParameter("cartaoNumero"));
            String nomeCartao = limpar(req.getParameter("cartaoNome"));
            String validade = limpar(req.getParameter("cartaoValidade"));
            String cvv = PedidoUtil.soDigitos(req.getParameter("cartaoCvv"));
            parcelas = lerInt(req.getParameter("parcelas"), 1);

            if (!PedidoUtil.cartaoValido(numeroCartao)) {
                erro = "Número do cartão inválido.";
            } else if (nomeCartao.isEmpty()) {
                erro = "Informe o nome impresso no cartão.";
            } else if (!PedidoUtil.validadeValida(validade)) {
                erro = "Validade do cartão inválida ou vencida.";
            } else if (cvv.length() < 3 || cvv.length() > 4) {
                erro = "CVV inválido.";
            } else if (parcelas < 1 || parcelas > PedidoUtil.maxParcelas(total)) {
                erro = "Número de parcelas inválido.";
            } else {
                // guardamos SÓ os 4 últimos dígitos. O restante é descartado.
                cartaoFinal = numeroCartao.substring(numeroCartao.length() - 4);
            }
        }

        if (erro == null) {

            Pedido pedido = new Pedido();
            pedido.setUsuarioId(lerInt(usuario.getId(), 0));
            pedido.setSubtotal(subtotal);
            pedido.setFrete(frete);
            pedido.setDesconto(desconto);
            pedido.setTotal(total);
            pedido.setFormaPagamento(forma);
            pedido.setParcelas(parcelas);
            pedido.setCartaoFinal(cartaoFinal);
            // cartão é aprovado na hora (simulação); Pix e boleto ficam aguardando
            pedido.setSituacao(Pedido.CARTAO.equals(forma) ? Pedido.PAGO : Pedido.AGUARDANDO);
            pedido.setDestNome(nome);
            pedido.setCep(cep);
            pedido.setEndereco(endereco);
            pedido.setNumero(numero);
            pedido.setComplemento(complemento);
            pedido.setBairro(bairro);
            pedido.setCidade(cidade);
            pedido.setUf(uf);

            for (ItemCarrinho item : carrinho.getItens()) {
                Livro livro = item.getLivro();
                pedido.getItens().add(new ItemPedido(
                        livro.getId(), livro.getNome(), livro.getAutor(), livro.getPreco(), item.getQuantidade()));
            }

            try {

                int pedidoId = new PedidoDao().criarPedido(pedido);

                carrinho.limpar();

                resp.sendRedirect("/pedido?id=" + pedidoId + "&novo=1");
                return;

            } catch (IllegalStateException e) {

                erro = e.getMessage();
            }
        }

        req.setAttribute("erro", erro);
        prepararTela(req, carrinho);
        req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
    }

    // devolve o carrinho já sincronizado; se estiver vazio/com problema, redireciona e devolve null
    private Carrinho carregarCarrinho(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        HttpSession session = req.getSession();
        Carrinho carrinho = (Carrinho) session.getAttribute("carrinho");

        if (carrinho != null) {
            carrinho.sincronizar(new LivroDao().findAllLivros());
        }

        if (carrinho == null || carrinho.isVazio()) {
            session.setAttribute("mensagem", "Seu carrinho está vazio.");
            resp.sendRedirect("/carrinho");
            return null;
        }

        for (ItemCarrinho item : carrinho.getItens()) {

            Livro livro = item.getLivro();

            if (item.getQuantidade() > livro.getEstoque()) {
                session.setAttribute("mensagem", "\"" + livro.getNome() + "\": temos apenas "
                        + livro.getEstoque() + " unidade(s) em estoque. Ajuste a quantidade antes de finalizar.");
                resp.sendRedirect("/carrinho");
                return null;
            }
        }

        return carrinho;
    }

    private void prepararTela(HttpServletRequest req, Carrinho carrinho) {

        double subtotal = PedidoUtil.arredondar(carrinho.getTotal());
        double frete = PedidoUtil.calcularFrete(subtotal);

        req.setAttribute("subtotal", subtotal);
        req.setAttribute("frete", frete);
        req.setAttribute("totalBase", PedidoUtil.arredondar(subtotal + frete));
        req.setAttribute("freteGratisAcima", PedidoUtil.FRETE_GRATIS_ACIMA);
        req.setAttribute("descontoPix", PedidoUtil.DESCONTO_PIX);
        req.setAttribute("maxParcelas", PedidoUtil.MAX_PARCELAS);
        req.setAttribute("parcelaMinima", PedidoUtil.PARCELA_MINIMA);
    }

    private String limpar(String texto) {
        return texto == null ? "" : texto.trim();
    }

    private int lerInt(String valor, int padrao) {
        try {
            return Integer.parseInt(valor.trim());
        } catch (Exception e) {
            return padrao;
        }
    }
}
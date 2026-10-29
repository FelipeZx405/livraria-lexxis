package br.com.lexxis.servlet;

import br.com.lexxis.dao.LivroDao;
import br.com.lexxis.model.Carrinho;
import br.com.lexxis.model.ItemCarrinho;
import br.com.lexxis.model.Livro;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/carrinho")
public class CarrinhoServlet extends HttpServlet {


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession();
        Carrinho carrinho = getCarrinho(session);

        carrinho.sincronizar(new LivroDao().findAllLivros());

        req.setAttribute("mensagem", session.getAttribute("mensagem"));
        session.removeAttribute("mensagem");

        req.getRequestDispatcher("/carrinho.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession();
        Carrinho carrinho = getCarrinho(session);

        String acao = req.getParameter("acao");
        String livroId = req.getParameter("id");
        int quantidade = lerQuantidade(req.getParameter("quantidade"));

        String mensagem = "";

        if ("adicionar".equals(acao)) {
            mensagem = adicionar(carrinho, livroId, quantidade);

        } else if ("atualizar".equals(acao)) {
            mensagem = atualizar(carrinho, livroId, quantidade);

        } else if ("remover".equals(acao)) {
            carrinho.remover(livroId);
            mensagem = "Livro removido do carrinho.";

        } else if ("limpar".equals(acao)) {
            carrinho.limpar();
            mensagem = "Carrinho esvaziado.";
        }

        session.setAttribute("mensagem", mensagem);

        resp.sendRedirect("/carrinho");
    }

    private String adicionar(Carrinho carrinho, String livroId, int quantidade) {

        Livro livro = buscarLivro(livroId);

        if (livro == null) {
            return "Livro inexistente ou removido.";
        }

        if (quantidade < 1) {
            quantidade = 1;
        }

        ItemCarrinho itemAtual = carrinho.getItem(livroId);
        int jaNoCarrinho = (itemAtual == null) ? 0 : itemAtual.getQuantidade();

        if (jaNoCarrinho + quantidade > livro.getEstoque()) {
            return "Estoque insuficiente. Temos apenas " + livro.getEstoque() + " unidade(s).";
        }

        carrinho.adicionar(livro, quantidade);
        return "Livro adicionado ao carrinho.";
    }

    private String atualizar(Carrinho carrinho, String livroId, int quantidade) {

        if (carrinho.getItem(livroId) == null) {
            return "Esse livro nao esta no carrinho.";
        }

        Livro livro = buscarLivro(livroId);

        if (livro == null) {
            carrinho.remover(livroId);
            return "Livro inexistente ou removido.";
        }

        if (quantidade > livro.getEstoque()) {
            return "Estoque insuficiente. Temos apenas " + livro.getEstoque() + " unidade(s).";
        }

        carrinho.atualizar(livroId, quantidade);

        if (quantidade > 0) {
            return "Quantidade atualizada.";
        }
        return "Livro removido do carrinho.";
    }

    private Carrinho getCarrinho(HttpSession session) {

        Carrinho carrinho = (Carrinho) session.getAttribute("carrinho");

        if (carrinho == null) {
            carrinho = new Carrinho();
            session.setAttribute("carrinho", carrinho);
        }

        return carrinho;
    }

    private Livro buscarLivro(String livroId) {

        if (livroId == null) {
            return null;
        }

        for (Livro livro : new LivroDao().findAllLivros()) {
            if (livroId.equals(livro.getId())) {
                return livro;
            }
        }

        return null;
    }

    private int lerQuantidade(String valor) {
        try {
            return Integer.parseInt(valor.trim());
        } catch (Exception e) {
            return 1;
        }
    }
}

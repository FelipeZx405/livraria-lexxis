package br.com.lexxis.servlet;

import br.com.lexxis.dao.UsuarioDao;
import br.com.lexxis.model.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/conta")
public class ContaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        req.getRequestDispatcher("/conta.jsp").forward(req, resp);

    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        Usuario logado = (Usuario) req.getSession().getAttribute("usuarioLogado");
        UsuarioDao dao = new UsuarioDao();

        String acao = req.getParameter("acao");

        String erro = null;
        String ok = null;

        if ("dados".equals(acao)) {

            String nome = req.getParameter("nome");
            String email = req.getParameter("email");

            if (vazio(nome) || vazio(email)) {

                erro = "Preencha o nome e o e-mail.";

            } else if (!dao.atualizarDados(logado.getId(), nome.trim(), email)) {

                erro = "Não foi possível salvar. Esse e-mail já pode estar em uso.";

            } else {

                // atualiza também o usuário guardado na sessão
                logado.setNome(nome.trim());
                logado.setEmail(email.trim().toLowerCase());
                req.getSession().setAttribute("usuarioLogado", logado);

                ok = "dados";
            }

        } else if ("senha".equals(acao)) {

            String senhaAtual = req.getParameter("senhaAtual");
            String novaSenha = req.getParameter("novaSenha");
            String confirmacao = req.getParameter("confirmacao");

            if (vazio(senhaAtual) || vazio(novaSenha) || vazio(confirmacao)) {

                erro = "Preencha os três campos de senha.";

            } else if (novaSenha.length() < 6) {

                erro = "A nova senha precisa ter pelo menos 6 caracteres.";

            } else if (!novaSenha.equals(confirmacao)) {

                erro = "A confirmação não é igual à nova senha.";

            } else if (dao.autenticar(logado.getEmail(), senhaAtual) == null) {

                erro = "Senha atual incorreta.";

            } else if (!dao.atualizarSenha(logado.getId(), novaSenha)) {

                erro = "Não foi possível alterar a senha.";

            } else {

                ok = "senha";
            }
        }

        if (erro != null) {
            req.setAttribute("erro", erro);
            req.setAttribute("secaoErro", acao);
            req.getRequestDispatcher("/conta.jsp").forward(req, resp);
            return;
        }

        resp.sendRedirect(ok == null ? "/conta" : "/conta?ok=" + ok);

    }

    private boolean vazio(String texto) {
        return texto == null || texto.trim().isEmpty();
    }
}
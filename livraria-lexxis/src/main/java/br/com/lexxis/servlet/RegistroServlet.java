package br.com.lexxis.servlet;

import br.com.lexxis.dao.UsuarioDao;
import br.com.lexxis.model.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/registro")
public class RegistroServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        req.getRequestDispatcher("/registro.jsp").forward(req, resp);

    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String nome = req.getParameter("nome");
        String email = req.getParameter("email");
        String senha = req.getParameter("senha");
        String confirmacao = req.getParameter("confirmacao");

        String erro = null;

        if (nome == null || nome.trim().isEmpty()
                || email == null || email.trim().isEmpty()
                || senha == null || senha.isEmpty()) {

            erro = "Preencha todos os campos";

        } else if (senha.length() < 6) {

            erro = "A senha precisa ter pelo menos 6 caracteres";

        } else if (!senha.equals(confirmacao)) {

            erro = "As senhas não são iguais";

        }

        if (erro == null) {

            Usuario usuario = new Usuario();
            usuario.setNome(nome.trim());
            usuario.setEmail(email);
            usuario.setSenha(senha);

            boolean salvou = new UsuarioDao().createUsuario(usuario);

            if (!salvou) {
                erro = "Não foi possível criar a conta (esse email já pode estar em uso)";
            }
        }

        if (erro != null) {
            req.setAttribute("erro", erro);
            req.getRequestDispatcher("/registro.jsp").forward(req, resp);
            return;
        }

        resp.sendRedirect("/login?registrado=1");

    }
}
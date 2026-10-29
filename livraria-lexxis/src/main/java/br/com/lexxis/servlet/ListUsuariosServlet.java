package br.com.lexxis.servlet;

import br.com.lexxis.dao.UsuarioDao;
import br.com.lexxis.model.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/find-all-usuarios")
public class ListUsuariosServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        UsuarioDao dao = new UsuarioDao();

        List<Usuario> allUsuarios = dao.findAllUsuarios();

        req.setAttribute("usuarios", allUsuarios);

        // a tela (JSP) ainda será criada
        req.getRequestDispatcher("/dashboard-usuarios.jsp").forward(req, resp);

    }
}

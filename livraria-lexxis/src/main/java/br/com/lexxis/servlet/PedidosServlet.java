package br.com.lexxis.servlet;

import br.com.lexxis.dao.PedidoDao;
import br.com.lexxis.model.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/pedidos")
public class PedidosServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        Usuario usuario = (Usuario) req.getSession().getAttribute("usuarioLogado");

        int usuarioId;

        try {
            usuarioId = Integer.parseInt(usuario.getId());
        } catch (Exception e) {
            usuarioId = -1;
        }

        req.setAttribute("pedidos", new PedidoDao().findByUsuario(usuarioId));

        req.getRequestDispatcher("/pedidos.jsp").forward(req, resp);
    }
}
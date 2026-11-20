package br.com.lexxis.servlet;

import br.com.lexxis.dao.PedidoDao;
import br.com.lexxis.model.Pedido;
import br.com.lexxis.model.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * /pedido?id=3  -> detalhes do pedido (também é a tela de confirmação)
 * POST acao=pagar|cancelar -> simula o pagamento ou cancela (só o dono do pedido)
 */
@WebServlet("/pedido")
public class PedidoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        Usuario usuario = (Usuario) req.getSession().getAttribute("usuarioLogado");

        int id = lerInt(req.getParameter("id"));
        Pedido pedido = id < 0 ? null : new PedidoDao().findById(id);

        boolean dono = pedido != null && String.valueOf(pedido.getUsuarioId()).equals(usuario.getId());

        // cliente só vê o próprio pedido; o administrador vê qualquer um
        if (pedido == null || (!dono && !usuario.isAdmin())) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Pedido não encontrado");
            return;
        }

        req.setAttribute("pedido", pedido);
        req.setAttribute("dono", dono);

        req.getRequestDispatcher("/pedido.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        Usuario usuario = (Usuario) req.getSession().getAttribute("usuarioLogado");

        int id = lerInt(req.getParameter("id"));
        int usuarioId = lerInt(usuario.getId());
        String acao = req.getParameter("acao");

        String ok = null;

        if (id >= 0 && usuarioId >= 0) {

            PedidoDao dao = new PedidoDao();

            if ("pagar".equals(acao)) {
                if (dao.marcarComoPago(id, usuarioId)) {
                    ok = "pago";
                }
            } else if ("cancelar".equals(acao)) {
                if (dao.cancelar(id, usuarioId)) {
                    ok = "cancelado";
                }
            }
        }

        resp.sendRedirect("/pedido?id=" + id + (ok == null ? "" : "&ok=" + ok));
    }

    private int lerInt(String valor) {
        try {
            return Integer.parseInt(valor.trim());
        } catch (Exception e) {
            return -1;
        }
    }
}
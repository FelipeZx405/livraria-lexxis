package br.com.lexxis.servlet;

import br.com.lexxis.dao.LivroDao;
import br.com.lexxis.model.Capa;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Entrega a imagem de capa de um livro: /capa?id=3
 * É pública (o catálogo e a home precisam mostrar as capas para quem não está logado).
 */
@WebServlet("/capa")
public class CapaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        String id = req.getParameter("id");

        Capa capa = id == null ? null : new LivroDao().findCapa(id);

        if (capa == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        resp.setContentType(capa.getTipo());
        resp.setContentLength(capa.getDados().length);
        resp.setHeader("X-Content-Type-Options", "nosniff");

        // com ?v=... na URL a imagem pode ficar guardada no navegador; sem o v, não
        resp.setHeader("Cache-Control", req.getParameter("v") != null ? "public, max-age=31536000" : "no-cache");

        resp.getOutputStream().write(capa.getDados());

    }
}
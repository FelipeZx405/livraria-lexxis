package br.com.lexxis.servlet;

import br.com.lexxis.dao.LivroDao;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/delete-livro")
public class DeleteLivroServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        String livroId = req.getParameter("id");

        new LivroDao().deleteById(livroId);

        resp.sendRedirect("/find-all-livros");

    }

}
package br.com.lexxis.servlet;

import br.com.lexxis.dao.LivroDao;
import br.com.lexxis.model.Livro;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/find-all-livros")
public class ListLivrosServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        LivroDao dao = new LivroDao();

        List<Livro> allLivros = dao.findAllLivros();

        req.setAttribute("livros", allLivros);

        req.getRequestDispatcher("/dashboard.jsp").forward(req, resp);

    }

}

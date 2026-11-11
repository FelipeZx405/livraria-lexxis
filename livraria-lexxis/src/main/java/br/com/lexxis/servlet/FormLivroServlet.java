package br.com.lexxis.servlet;

import br.com.lexxis.dao.LivroDao;
import br.com.lexxis.model.Livro;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Abre o formulário de livro (index.jsp).
 *  - /form-livro          → formulário vazio (adicionar)
 *  - /form-livro?id=3     → formulário preenchido com o livro 3 (editar)
 */
@WebServlet("/form-livro")
public class FormLivroServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String id = req.getParameter("id");

        if (id != null && !id.trim().isEmpty()) {

            Livro livro = new LivroDao().findById(id.trim());

            if (livro != null) {
                req.setAttribute("livro", livro);
            }
        }

        req.getRequestDispatcher("/index.jsp").forward(req, resp);

    }
}
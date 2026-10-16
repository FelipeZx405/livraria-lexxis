package br.com.lexxis.servlet;

import br.com.lexxis.dao.LivroDao;
import br.com.lexxis.model.Livro;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;


@WebServlet("/create-livro")
public class CreateLivroServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

//        String id = request.getParameter("id");
        String nome = request.getParameter("nome");


        Livro livro = new Livro();
        livro.setNome(nome);

        LivroDao dao = new LivroDao();
        dao.createLivro(livro);
//
//        if (id.isBlank()){
//
//            LivroDao
//        }

        response.sendRedirect("/find-all-livros");
    }


}

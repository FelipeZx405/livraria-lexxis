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

        request.setCharacterEncoding("UTF-8");

        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String autor = request.getParameter("autor");
        String descricao = request.getParameter("descricao");
        String precoParam = request.getParameter("preco");


        Livro livro = new Livro();
        livro.setNome(name);
        livro.setAutor(autor);
        livro.setDescricao(descricao);

        if (precoParam != null && !precoParam.isEmpty()) {
            livro.setPreco(Double.parseDouble(precoParam));
        }
        String estoqueParam = request.getParameter("estoque");

        if (estoqueParam != null && !estoqueParam.isEmpty()) {
            livro.setEstoque(Integer.parseInt(estoqueParam));
        }

        LivroDao dao = new LivroDao();

        if (id.isEmpty()){

            dao.createLivro(livro);

        }else {
            livro.setId(id);
            dao.updateLivro(livro);
        }

        response.sendRedirect("/find-all-livros");
    }


}

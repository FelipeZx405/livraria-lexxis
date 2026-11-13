package br.com.lexxis.servlet;

import br.com.lexxis.dao.LivroDao;
import br.com.lexxis.model.Livro;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        List<Livro> todos = new LivroDao().findAllLivros();

        // quantos livros existem em cada categoria
        Map<String, Integer> contagem = new HashMap<String, Integer>();

        for (Livro livro : todos) {

            String categoria = livro.getCategoria();

            if (categoria == null || categoria.trim().isEmpty()) {
                categoria = "Outros";
            }

            Integer atual = contagem.get(categoria);
            contagem.put(categoria, atual == null ? 1 : atual + 1);
        }

        // destaques: os 4 livros mais recentes (maior id) que tem estoque
        List<Livro> disponiveis = new ArrayList<Livro>();

        for (Livro livro : todos) {
            if (livro.getEstoque() > 0) {
                disponiveis.add(livro);
            }
        }

        Collections.sort(disponiveis, new Comparator<Livro>() {
            @Override
            public int compare(Livro a, Livro b) {
                return idComoNumero(b) - idComoNumero(a);
            }
        });

        List<Livro> destaques = new ArrayList<Livro>(disponiveis.subList(0, Math.min(4, disponiveis.size())));

        req.setAttribute("destaques", destaques);
        req.setAttribute("contagem", contagem);
        req.setAttribute("totalLivros", todos.size());

        req.getRequestDispatcher("/home.jsp").forward(req, resp);
    }

    private int idComoNumero(Livro livro) {
        try {
            return Integer.parseInt(livro.getId());
        } catch (Exception e) {
            return 0;
        }
    }
}
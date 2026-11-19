package br.com.lexxis.servlet;

import br.com.lexxis.dao.LivroDao;
import br.com.lexxis.model.Livro;
import br.com.lexxis.util.ImagemUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;


@WebServlet("/create-livro")
@MultipartConfig(maxFileSize = 2 * 1024 * 1024, maxRequestSize = 3 * 1024 * 1024)
public class CreateLivroServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // o formulário agora envia arquivo (multipart): a capa chega como uma "parte" da requisição
        Part capa;

        try {
            capa = request.getPart("capa");
        } catch (IllegalStateException e) {
            // imagem maior que o limite do @MultipartConfig (2 MB)
            response.sendRedirect("/find-all-livros?erro=capa");
            return;
        }

        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String autor = request.getParameter("autor");
        String descricao = request.getParameter("descricao");
        String precoParam = request.getParameter("preco");
        String categoria = request.getParameter("categoria");


        Livro livro = new Livro();
        livro.setNome(name);
        livro.setAutor(autor);
        livro.setDescricao(descricao);

        if (categoria == null || categoria.trim().isEmpty()) {
            livro.setCategoria("Outros");
        } else {
            livro.setCategoria(categoria.trim());
        }

        if (precoParam != null && !precoParam.isEmpty()) {
            livro.setPreco(Double.parseDouble(precoParam));
        }
        String estoqueParam = request.getParameter("estoque");

        if (estoqueParam != null && !estoqueParam.isEmpty()) {
            livro.setEstoque(Integer.parseInt(estoqueParam));
        }

        LivroDao dao = new LivroDao();

        String livroId;

        if (id == null || id.isEmpty()){

            livroId = dao.createLivro(livro);

        }else {
            livro.setId(id);
            dao.updateLivro(livro);
            livroId = id;
        }

        salvarCapa(request, dao, livroId, capa);

        response.sendRedirect("/find-all-livros");
    }

    private void salvarCapa(HttpServletRequest request, LivroDao dao, String livroId, Part capa) throws IOException {

        if (livroId == null) {
            return;
        }

        // caixinha "Remover a capa atual"
        if ("1".equals(request.getParameter("removerCapa"))) {
            dao.removerCapa(livroId);
        }

        // nenhum arquivo escolhido: mantém a capa que já existe
        if (capa == null || capa.getSize() == 0) {
            return;
        }

        byte[] bytes;

        try (InputStream entrada = capa.getInputStream()) {
            bytes = ImagemUtil.lerBytes(entrada, ImagemUtil.LIMITE_BYTES);
        }

        String tipo = ImagemUtil.detectarTipo(bytes);

        if (tipo == null) {
            System.out.println("Capa ignorada: o arquivo não é uma imagem JPG, PNG, GIF ou WEBP válida");
        } else {
            dao.atualizarCapa(livroId, bytes, tipo);
        }

        capa.delete();
    }


}
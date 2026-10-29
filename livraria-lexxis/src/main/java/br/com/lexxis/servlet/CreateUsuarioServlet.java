package br.com.lexxis.servlet;

import br.com.lexxis.dao.UsuarioDao;
import br.com.lexxis.model.Usuario;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/create-usuario")
public class CreateUsuarioServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String id = request.getParameter("id");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String senha = request.getParameter("senha");

        Usuario usuario = new Usuario();
        usuario.setNome(name);
        usuario.setEmail(email);
        usuario.setSenha(senha);

        UsuarioDao dao = new UsuarioDao();

        if (id.isEmpty()){

            dao.createUsuario(usuario);

        }else {
            usuario.setId(id);
            dao.updateUsuario(usuario);
        }

        response.sendRedirect("/find-all-usuarios");
    }

    //CREATE TABLE USUARIO(ID INT PRIMARY KEY AUTO_INCREMENT, NAME VARCHAR(255), EMAIL VARCHAR(255) UNIQUE, SENHA VARCHAR(255));
}

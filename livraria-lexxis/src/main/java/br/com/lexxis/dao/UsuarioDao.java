package br.com.lexxis.dao;

import br.com.lexxis.model.Usuario;
import br.com.lexxis.servlet.config.ConnectionPoolConfig;
import br.com.lexxis.util.SenhaUtil;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class UsuarioDao {

    // quem se cadastra pelo site entra como CLIENTE (o banco usa o valor padrão da coluna PERFIL)
    public boolean createUsuario(Usuario usuario){

        String SQL = "INSERT INTO USUARIO (NAME, EMAIL, SENHA) VALUES (?, ?, ?)";

        try {

            Connection connection = ConnectionPoolConfig.getConnection();

            PreparedStatement preparedStatement = connection.prepareStatement(SQL);

            preparedStatement.setString(1, usuario.getNome());
            preparedStatement.setString(2, usuario.getEmail().trim().toLowerCase());
            preparedStatement.setString(3, SenhaUtil.gerarHash(usuario.getSenha()));
            preparedStatement.execute();

            System.out.println("Sucesso ao inserir o usuário");

            connection.close();

            return true;

        } catch (Exception e) {

            System.out.println("Falha ao inserir o usuário no banco de dados: " + e.getMessage());

            return false;

        }

    }

    public List<Usuario> findAllUsuarios() {

        String SQL = "SELECT * FROM USUARIO";

        try {

            Connection connection = DriverManager.getConnection("jdbc:h2:~/test", "sa", "sa");

            PreparedStatement preparedStatement = connection.prepareStatement(SQL);

            System.out.println("sucesso na conexão com o banco de dados");

            ResultSet resultSet = preparedStatement.executeQuery();

            List<Usuario> usuarios = new ArrayList<>();

            while (resultSet.next()) {

                Usuario usuario = new Usuario();
                usuario.setId(resultSet.getString("ID"));
                usuario.setNome(resultSet.getString("NAME"));
                usuario.setEmail(resultSet.getString("EMAIL"));
                usuario.setSenha(resultSet.getString("SENHA"));
                usuario.setPerfil(resultSet.getString("PERFIL"));
                usuarios.add(usuario);

            }

            System.out.println("Sucesso ao consultar os dados no DB");

            connection.close();

            return usuarios;

        } catch (Exception e) {

            System.out.println("Erro ao consultar os usuários no banco de dados" + e.getMessage());

            return Collections.emptyList();
        }
    }

    public void deleteById(String id) {

        String SQL = "DELETE USUARIO WHERE ID = ?";

        try {

            Connection connection = DriverManager.getConnection("jdbc:h2:~/test", "sa", "sa");

            System.out.println("sucesso ao conectar com o banco de dados");

            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            preparedStatement.setString(1, id);
            preparedStatement.execute();

            System.out.println("sucesso ao deletar o usuário com o id: " + id);

            connection.close();

        } catch (Exception e) {

            System.out.println("Falha ao deletar o usuário: " + e.getMessage());

        }

    }

    public void updateUsuario(Usuario usuario) {

        String SQL = "UPDATE USUARIO SET NAME = ?, EMAIL = ?, SENHA = ? WHERE ID = ?";

        try {

            Connection connection = DriverManager.getConnection("jdbc:h2:~/test", "sa","sa");

            System.out.println("success in database connection");

            PreparedStatement preparedStatement = connection.prepareStatement(SQL);

            preparedStatement.setString(1, usuario.getNome());
            preparedStatement.setString(2, usuario.getEmail().trim().toLowerCase());
            preparedStatement.setString(3, SenhaUtil.gerarHash(usuario.getSenha()));
            preparedStatement.setString(4, usuario.getId());
            preparedStatement.execute();

            System.out.println("Sucesso ao atualizar o usuário");

            connection.close();

        } catch (Exception e) {

            System.out.println("Falha ao atualizar o usuário");
            System.out.println("Error: " + e.getMessage());

        }

    }

    // devolve o usuário (sem a senha, mas COM o perfil) se email e senha conferem; senão devolve null
    public Usuario autenticar(String email, String senha) {

        String SQL = "SELECT * FROM USUARIO WHERE EMAIL = ?";

        try {

            Connection connection = DriverManager.getConnection("jdbc:h2:~/test", "sa", "sa");

            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            preparedStatement.setString(1, email.trim().toLowerCase());

            ResultSet resultSet = preparedStatement.executeQuery();

            Usuario usuario = null;

            if (resultSet.next()) {

                String hashSalvo = resultSet.getString("SENHA");

                if (SenhaUtil.conferir(senha, hashSalvo)) {

                    usuario = new Usuario();
                    usuario.setId(resultSet.getString("ID"));
                    usuario.setNome(resultSet.getString("NAME"));
                    usuario.setEmail(resultSet.getString("EMAIL"));
                    usuario.setPerfil(resultSet.getString("PERFIL"));

                }
            }

            connection.close();

            return usuario;

        } catch (Exception e) {

            System.out.println("Erro ao autenticar o usuário: " + e.getMessage());

            return null;
        }
    }

    // atualiza nome e e-mail do usuário. Devolve false se der erro (por exemplo, e-mail já usado por outra conta)
    public boolean atualizarDados(String id, String nome, String email) {

        String SQL = "UPDATE USUARIO SET NAME = ?, EMAIL = ? WHERE ID = ?";

        try (Connection connection = ConnectionPoolConfig.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SQL)) {

            preparedStatement.setString(1, nome);
            preparedStatement.setString(2, email.trim().toLowerCase());
            preparedStatement.setInt(3, Integer.parseInt(id));
            preparedStatement.execute();

            System.out.println("Sucesso ao atualizar os dados do usuário");

            return true;

        } catch (Exception e) {

            System.out.println("Falha ao atualizar os dados do usuário: " + e.getMessage());

            return false;
        }
    }

    // troca só a senha (já salva com hash)
    public boolean atualizarSenha(String id, String novaSenha) {

        String SQL = "UPDATE USUARIO SET SENHA = ? WHERE ID = ?";

        try (Connection connection = ConnectionPoolConfig.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SQL)) {

            preparedStatement.setString(1, SenhaUtil.gerarHash(novaSenha));
            preparedStatement.setInt(2, Integer.parseInt(id));
            preparedStatement.execute();

            System.out.println("Sucesso ao atualizar a senha do usuário");

            return true;

        } catch (Exception e) {

            System.out.println("Falha ao atualizar a senha do usuário: " + e.getMessage());

            return false;
        }
    }
}
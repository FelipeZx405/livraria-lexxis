package br.com.lexxis.dao;

import br.com.lexxis.model.Livro;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class LivroDao {

    public void createLivro(Livro livro){

        String SQL = "INSERT INTO LIVRO (NAME) VALUES (?)";

        try {

            Connection connection = DriverManager.getConnection("jdbc:h2:~/test", "sa","sa");

            System.out.println("Sucesso na conexão com o banco de dados");

            PreparedStatement preparedStatement = connection.prepareStatement(SQL);

            preparedStatement.setString(1, livro.getNome());
            preparedStatement.execute();

            System.out.println("Sucesso ao inserir o livro");

            connection.close();

        } catch (Exception e) {

            System.out.println("Falha ao inserir o livro no banco de dados");

        }

    }

    public List<Livro> findAllLivros() {

        String SQL = "SELECT * FROM LIVRO";

        try {

            Connection connection = DriverManager.getConnection("jdbc:h2:~/test", "sa", "sa");

            PreparedStatement preparedStatement = connection.prepareStatement(SQL);

            System.out.println("sucesso na conexão com o banco de dados");

            ResultSet resultSet = preparedStatement.executeQuery();

            List<Livro> livros = new ArrayList<>();

            while (resultSet.next()) {

                Livro livro = new Livro();
                String nome = resultSet.getString("NAME");
                String id = resultSet.getString("id");
                livro.setNome(nome);
                livro.setId(id);
                livros.add(livro);

            }

            System.out.println("Sucesso ao consultar os dados no DB");

            connection.close();

            return livros;

        } catch (Exception e) {

            System.out.println("Erro ao consultar os livros no banco de dados" + e.getMessage());

            return Collections.emptyList();
        }
    }

    public void deleteById(String id) {

        String SQL = "DELETE LIVRO WHERE ID = ?";

        try {

            Connection connection = DriverManager.getConnection("jdbc:h2:~/test", "sa", "sa");

            System.out.println("sucesso ao conectar com o banco de dados");

            PreparedStatement preparedStatement = connection.prepareStatement(SQL);
            preparedStatement.setString(1, id);
            preparedStatement.execute();

            System.out.println("sucesso ao deletar o livro com o id: " + id);

            connection.close();

        } catch (Exception e) {

            System.out.println("Falha ao conectar com o banco de dados!!!");

        }

    }

    public void updateLivro(Livro livro) {

        String SQL = "UPDATE LIVRO SET NAME = ? WHERE ID = ?";

        try {

            Connection connection = DriverManager.getConnection("jdbc:h2:~/test", "sa","sa");

            System.out.println("success in database connection");

            PreparedStatement preparedStatement = connection.prepareStatement(SQL);

            preparedStatement.setString(1, livro.getNome());
            preparedStatement.setString(2, livro.getId());
            preparedStatement.execute();

            System.out.println("Sucesso ao atualizar o livro");

            connection.close();

        } catch (Exception e) {

            System.out.println("Falha ao conectar no Banco de Dados");
            System.out.println("Error: " + e.getMessage());

        }

    }
}

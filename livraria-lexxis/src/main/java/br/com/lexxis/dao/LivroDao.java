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

        String SQL = "INSERT INTO CAR (NAME) VALUES (?)";

        try {

            Connection connection = DriverManager.getConnection("jdbc:h2:~/test", "sa","sa");

            System.out.println("sucesso na conexão com o banco de dados");

            PreparedStatement preparedStatement = connection.prepareStatement(SQL);

            preparedStatement.setString(1, livro.getNome());
            preparedStatement.execute();

            System.out.println("sucesso em inserir livro");

            connection.close();

        } catch (Exception e) {

            System.out.println("falha na conexão com o banco de dados");

        }

    }

    public List<Livro> findAllLivros() {

        String SQL = "SELECT * FROM CAR";

        try {
            Connection connection = DriverManager.getConnection("jdbc:h2:~/test", "sa", "sa");

            System.out.println("sucesso na conexão com o banco de dados");

            PreparedStatement preparedStatement = connection.prepareStatement(SQL);

            ResultSet resultSet = preparedStatement.executeQuery();

            List<Livro> livros = new ArrayList<>();

            while (resultSet.next()) {

                String carName = resultSet.getString("nome");

                Livro livro = new Livro();
                String nome = resultSet.getString("nome");
                String id = resultSet.getString("id");
                livro.setNome(nome);
                livro.setId(id);
                livros.add(livro);

            }

            System.out.println("success in select * livro");

            connection.close();

            return livros;

        } catch (Exception e) {

            System.out.println("fail in database connection");

            return Collections.emptyList();
        }
    }
}

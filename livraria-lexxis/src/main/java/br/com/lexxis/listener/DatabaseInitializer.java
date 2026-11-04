package br.com.lexxis.listener;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

@WebListener
public class DatabaseInitializer implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {

        String[] scripts = {

                "CREATE TABLE IF NOT EXISTS LIVRO (ID INT PRIMARY KEY AUTO_INCREMENT, NAME VARCHAR(255))",
                "ALTER TABLE LIVRO ADD COLUMN IF NOT EXISTS AUTOR VARCHAR(255)",
                "ALTER TABLE LIVRO ADD COLUMN IF NOT EXISTS DESCRICAO VARCHAR(1000)",
                "ALTER TABLE LIVRO ADD COLUMN IF NOT EXISTS PRECO DOUBLE DEFAULT 0",
                "ALTER TABLE LIVRO ADD COLUMN IF NOT EXISTS ESTOQUE INT DEFAULT 0",

                "CREATE TABLE IF NOT EXISTS USUARIO (ID INT PRIMARY KEY AUTO_INCREMENT, NAME VARCHAR(255), EMAIL VARCHAR(255) UNIQUE, SENHA VARCHAR(255))"

        };

        try {

            Connection connection = DriverManager.getConnection("jdbc:h2:~/test", "sa", "sa");

            Statement statement = connection.createStatement();

            for (String sql : scripts) {
                statement.execute(sql);
            }

            connection.close();

            System.out.println("Banco de dados pronto: tabelas verificadas");

        } catch (Exception e) {

            System.out.println("Erro ao preparar o banco de dados: " + e.getMessage());

        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
    }
}
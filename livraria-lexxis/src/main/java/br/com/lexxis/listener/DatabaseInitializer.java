package br.com.lexxis.listener;

import br.com.lexxis.util.SenhaUtil;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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
                "ALTER TABLE LIVRO ADD COLUMN IF NOT EXISTS CATEGORIA VARCHAR(50) DEFAULT 'Outros'",

                "CREATE TABLE IF NOT EXISTS USUARIO (ID INT PRIMARY KEY AUTO_INCREMENT, NAME VARCHAR(255), EMAIL VARCHAR(255) UNIQUE, SENHA VARCHAR(255))",

                // NOVO: perfil do usuário. Quem se cadastra no site sempre fica como CLIENTE
                "ALTER TABLE USUARIO ADD COLUMN IF NOT EXISTS PERFIL VARCHAR(10) DEFAULT 'CLIENTE'"

        };

        try (Connection connection = DriverManager.getConnection("jdbc:h2:~/test", "sa", "sa");
             Statement statement = connection.createStatement()) {

            for (String sql : scripts) {
                statement.execute(sql);
            }

            System.out.println("Banco de dados pronto: tabelas verificadas");

            // cria a conta do administrador se ainda não existir nenhum
            int admins = 0;

            try (ResultSet resultSet = statement.executeQuery("SELECT COUNT(*) FROM USUARIO WHERE PERFIL = 'ADM'")) {
                resultSet.next();
                admins = resultSet.getInt(1);
            }

            if (admins == 0) {

                String SQL = "INSERT INTO USUARIO (NAME, EMAIL, SENHA, PERFIL) VALUES (?, ?, ?, 'ADM')";

                try (PreparedStatement preparedStatement = connection.prepareStatement(SQL)) {
                    preparedStatement.setString(1, "Administrador");
                    preparedStatement.setString(2, "admin@lexxis.com");
                    preparedStatement.setString(3, SenhaUtil.gerarHash("admin123"));
                    preparedStatement.execute();
                }

                System.out.println("Conta do ADM criada: admin@lexxis.com / admin123 (troque a senha em Minha conta)");
            }

        } catch (Exception e) {

            System.out.println("Erro ao preparar o banco de dados: " + e.getMessage());

        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
    }
}
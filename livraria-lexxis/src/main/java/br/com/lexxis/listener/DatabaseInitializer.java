package br.com.lexxis.listener;

import br.com.lexxis.util.ImagemUtil;
import br.com.lexxis.util.SenhaUtil;

import javax.servlet.ServletContext;
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

    // Livros iniciais da loja, na ordem: nome, autor, descrição, preço, estoque, categoria e nome do arquivo da capa.
    // A capa fica em src/main/webapp/img/capa/<nome do arquivo>.png (ou .jpg, .webp, .gif); escreva o nome sem a extensão.
    // Se o arquivo não existir, o livro fica sem capa. Para ter mais um livro fixo, acrescente uma linha.
    private static final Object[][] LIVROS_INICIAIS = {
            {"Dom Casmurro", "Machado de Assis",
                    "Classico da literatura brasileira em que Bentinho relembra o amor por Capitu e as duvidas que marcaram sua vida.",
                    39.90, 15, "Romance", "Dom Casmurro"},
            {"1984", "George Orwell",
                    "Distopia sobre um regime totalitario que vigia e controla tudo, até o pensamento de seus cidadaos.",
                    49.90, 20, "Ficção Científica", "1984"},
            {"O Pequeno Principe", "Antoine de Saint-Exupery",
                    "Fabula de um pequeno principe que viaja entre planetas e fala de amizade, amor e do que realmente importa.",
                    29.90, 30, "Outros", "O pequeno principe"},
            {"Harry Potter e a Pedra Filosofal", "J.K. Rowling",
                    "Aos onze anos, Harry descobre que é bruxo e começa sua jornada na Escola de Magia e Bruxaria de Hogwarts.",
                    59.90, 12, "Outros", "Harry Potter"},
            {"Biblia Sagrada", "Vários autores",
                    "Conjunto de livros sagrados do cristianismo, reunindo o Antigo e o Novo Testamento.",
                    79.90, 25, "Outros", "Biblia"},
            {"Cartas de um Diabo a seu Aprendiz", "C.S. Lewis",
                    "Um demonio veterano escreve cartas ao sobrinho aprendiz, ensinando como afastar uma pessoa da fe, em uma satira sobre a natureza humana.",
                    44.90, 10, "Outros", "CartadoDiabo"},
            {"O Segredo da Mente Milionária", "T. Harv Eker",
                    "Mostra como as crencas e os habitos em relacao ao dinheiro influenciam a vida financeira e como muda-los para prosperar.",
                    42.90, 18, "Educação", "OsegredoDaMenteMilionaria"},
            {"Pai Rico, Pai Pobre", "Robert T. Kiyosaki",
                    "Compara as licoes de dinheiro de dois pais e ensina conceitos de educacao financeira, investimentos e independencia.",
                    49.90, 22, "Educacao", "PaiRicoPaiPobre"}
    };

    @Override
    public void contextInitialized(ServletContextEvent sce) {

        String[] scripts = {

                "CREATE TABLE IF NOT EXISTS LIVRO (ID INT PRIMARY KEY AUTO_INCREMENT, NAME VARCHAR(255))",
                "ALTER TABLE LIVRO ADD COLUMN IF NOT EXISTS AUTOR VARCHAR(255)",
                "ALTER TABLE LIVRO ADD COLUMN IF NOT EXISTS DESCRICAO VARCHAR(1000)",
                "ALTER TABLE LIVRO ADD COLUMN IF NOT EXISTS PRECO DOUBLE DEFAULT 0",
                "ALTER TABLE LIVRO ADD COLUMN IF NOT EXISTS ESTOQUE INT DEFAULT 0",
                "ALTER TABLE LIVRO ADD COLUMN IF NOT EXISTS CATEGORIA VARCHAR(50) DEFAULT 'Outros'",

                // NOVO: a capa do livro (a imagem fica guardada no próprio banco)
                "ALTER TABLE LIVRO ADD COLUMN IF NOT EXISTS CAPA BLOB",
                "ALTER TABLE LIVRO ADD COLUMN IF NOT EXISTS CAPA_TIPO VARCHAR(30)",
                "ALTER TABLE LIVRO ADD COLUMN IF NOT EXISTS CAPA_VERSAO BIGINT DEFAULT 0",

                "CREATE TABLE IF NOT EXISTS USUARIO (ID INT PRIMARY KEY AUTO_INCREMENT, NAME VARCHAR(255), EMAIL VARCHAR(255) UNIQUE, SENHA VARCHAR(255))",

                // perfil do usuário. Quem se cadastra no site sempre fica como CLIENTE
                "ALTER TABLE USUARIO ADD COLUMN IF NOT EXISTS PERFIL VARCHAR(10) DEFAULT 'CLIENTE'"

        };

        try (Connection connection = DriverManager.getConnection("jdbc:h2:~/test", "sa", "sa");
             Statement statement = connection.createStatement()) {

            for (String sql : scripts) {
                statement.execute(sql);
            }

            System.out.println("Banco de dados pronto: tabelas verificadas");

            criarAdminSeNecessario(connection, statement);
            criarLivrosIniciaisSeNecessario(connection);
            aplicarCapasIniciais(connection, sce.getServletContext());

        } catch (Exception e) {

            System.out.println("Erro ao preparar o banco de dados: " + e.getMessage());

        }
    }

    // cria a conta do administrador se ainda não existir nenhum
    private void criarAdminSeNecessario(Connection connection, Statement statement) throws Exception {

        int admins = 0;

        try (ResultSet resultSet = statement.executeQuery("SELECT COUNT(*) FROM USUARIO WHERE PERFIL = 'ADM'")) {
            resultSet.next();
            admins = resultSet.getInt(1);
        }

        if (admins > 0) {
            return;
        }

        String SQL = "INSERT INTO USUARIO (NAME, EMAIL, SENHA, PERFIL) VALUES (?, ?, ?, 'ADM')";

        try (PreparedStatement preparedStatement = connection.prepareStatement(SQL)) {
            preparedStatement.setString(1, "Administrador");
            preparedStatement.setString(2, "admin@lexxis.com");
            preparedStatement.setString(3, SenhaUtil.gerarHash("admin123"));
            preparedStatement.execute();
        }

        System.out.println("Conta do ADM criada: admin@lexxis.com / admin123 (troque a senha em Minha conta)");
    }

    // cadastra cada livro inicial que ainda não existe (a conferência é pelo nome do livro)
    private void criarLivrosIniciaisSeNecessario(Connection connection) throws Exception {

        String SQL_EXISTE = "SELECT COUNT(*) FROM LIVRO WHERE NAME = ?";
        String SQL_INSERIR = "INSERT INTO LIVRO (NAME, AUTOR, DESCRICAO, PRECO, ESTOQUE, CATEGORIA) VALUES (?, ?, ?, ?, ?, ?)";

        int cadastrados = 0;

        try (PreparedStatement existe = connection.prepareStatement(SQL_EXISTE);
             PreparedStatement inserir = connection.prepareStatement(SQL_INSERIR)) {

            for (Object[] livro : LIVROS_INICIAIS) {

                existe.setString(1, (String) livro[0]);

                int quantidade = 0;

                try (ResultSet resultSet = existe.executeQuery()) {
                    resultSet.next();
                    quantidade = resultSet.getInt(1);
                }

                if (quantidade > 0) {
                    continue;
                }

                inserir.setString(1, (String) livro[0]);
                inserir.setString(2, (String) livro[1]);
                inserir.setString(3, (String) livro[2]);
                inserir.setDouble(4, (Double) livro[3]);
                inserir.setInt(5, (Integer) livro[4]);
                inserir.setString(6, (String) livro[5]);
                inserir.execute();

                cadastrados++;
            }
        }

        if (cadastrados > 0) {
            System.out.println("Livros iniciais cadastrados: " + cadastrados);
        }
    }

    // coloca a capa nos livros iniciais que ainda não têm (não mexe em capas enviadas pelo painel)
    private void aplicarCapasIniciais(Connection connection, ServletContext contexto) throws Exception {

        String SQL = "UPDATE LIVRO SET CAPA = ?, CAPA_TIPO = ?, CAPA_VERSAO = ? WHERE NAME = ? AND CAPA_TIPO IS NULL";

        try (PreparedStatement preparedStatement = connection.prepareStatement(SQL)) {

            for (Object[] livro : LIVROS_INICIAIS) {

                byte[] bytes = ImagemUtil.carregarCapaInicial(contexto, (String) livro[6]);
                String tipo = ImagemUtil.detectarTipo(bytes);

                if (tipo == null) {
                    continue;
                }

                preparedStatement.setBytes(1, bytes);
                preparedStatement.setString(2, tipo);
                preparedStatement.setLong(3, System.currentTimeMillis());
                preparedStatement.setString(4, (String) livro[0]);

                if (preparedStatement.executeUpdate() > 0) {
                    System.out.println("Capa inicial aplicada: " + livro[0]);
                }
            }
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
    }
}
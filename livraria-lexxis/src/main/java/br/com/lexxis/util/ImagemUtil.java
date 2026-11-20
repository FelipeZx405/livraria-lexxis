package br.com.lexxis.util;

import javax.servlet.ServletContext;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;
import java.util.List;
import java.util.Set;

public class ImagemUtil {

    public static final int LIMITE_BYTES = 2 * 1024 * 1024; // 2 MB

    // pasta (dentro de webapp) onde ficam as capas dos livros iniciais
    private static final String PASTA_CAPAS = "/img/capa/";

    private static final List<String> EXTENSOES = Arrays.asList(".jpg", ".jpeg", ".png", ".webp", ".gif");

    // lê o arquivo inteiro; devolve null se passar do limite de tamanho
    public static byte[] lerBytes(InputStream entrada, int limite) throws IOException {

        ByteArrayOutputStream saida = new ByteArrayOutputStream();
        byte[] buffer = new byte[8192];
        int total = 0;
        int lidos;

        while ((lidos = entrada.read(buffer)) != -1) {

            total += lidos;

            if (total > limite) {
                return null;
            }

            saida.write(buffer, 0, lidos);
        }

        return saida.toByteArray();
    }

    // descobre o tipo olhando os primeiros bytes do arquivo (não confiamos no nome nem no tipo que o navegador diz).
    // Devolve null se não for JPG, PNG, GIF ou WEBP.
    public static String detectarTipo(byte[] b) {

        if (b == null || b.length < 12) {
            return null;
        }

        // JPEG: FF D8 FF
        if ((b[0] & 0xFF) == 0xFF && (b[1] & 0xFF) == 0xD8 && (b[2] & 0xFF) == 0xFF) {
            return "image/jpeg";
        }

        // PNG: 89 'P' 'N' 'G'
        if ((b[0] & 0xFF) == 0x89 && b[1] == 'P' && b[2] == 'N' && b[3] == 'G') {
            return "image/png";
        }

        // GIF: "GIF8"
        if (b[0] == 'G' && b[1] == 'I' && b[2] == 'F' && b[3] == '8') {
            return "image/gif";
        }

        // WEBP: "RIFF" .... "WEBP"
        if (b[0] == 'R' && b[1] == 'I' && b[2] == 'F' && b[3] == 'F'
                && b[8] == 'W' && b[9] == 'E' && b[10] == 'B' && b[11] == 'P') {
            return "image/webp";
        }

        return null;
    }

    // procura uma capa dos livros iniciais dentro de webapp/img/capa (ex.: "Dom Casmurro" acha "Dom Casmurro.png").
    // A comparação ignora maiúsculas, espaços e traços. Devolve null se não achar o arquivo.
    public static byte[] carregarCapaInicial(ServletContext contexto, String nomeBase) {

        Set<String> arquivos = contexto.getResourcePaths(PASTA_CAPAS);

        if (arquivos == null) {
            System.out.println("Pasta das capas iniciais não encontrada: " + PASTA_CAPAS);
            return null;
        }

        String procurado = simplificar(nomeBase);

        for (String caminho : arquivos) {

            String arquivo = caminho.substring(caminho.lastIndexOf('/') + 1);
            int ponto = arquivo.lastIndexOf('.');

            if (ponto < 0) {
                continue;
            }

            String base = arquivo.substring(0, ponto);
            String extensao = arquivo.substring(ponto).toLowerCase();

            if (!EXTENSOES.contains(extensao) || !simplificar(base).equals(procurado)) {
                continue;
            }

            try (InputStream entrada = contexto.getResourceAsStream(caminho)) {

                if (entrada == null) {
                    continue;
                }

                byte[] bytes = lerBytes(entrada, LIMITE_BYTES);

                if (bytes == null) {
                    System.out.println("Capa inicial ignorada (maior que 2 MB): " + arquivo);
                }

                return bytes;

            } catch (IOException e) {

                System.out.println("Erro ao ler a capa inicial " + arquivo + ": " + e.getMessage());

            }
        }

        System.out.println("Capa inicial não encontrada em " + PASTA_CAPAS + ": " + nomeBase);

        return null;
    }

    // deixa só letras e números em minúsculo: "Harry Potter " e "harry-potter" viram "harrypotter"
    private static String simplificar(String texto) {
        return texto.toLowerCase().replaceAll("[^a-z0-9]", "");
    }
}
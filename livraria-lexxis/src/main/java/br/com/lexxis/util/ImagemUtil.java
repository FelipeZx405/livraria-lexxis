package br.com.lexxis.util;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;

public class ImagemUtil {

    public static final int LIMITE_BYTES = 2 * 1024 * 1024; // 2 MB

    private static final String[] EXTENSOES = {".jpg", ".jpeg", ".png", ".webp", ".gif"};

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

    // procura uma capa dos livros iniciais dentro do projeto: src/main/resources/capas-iniciais/<nomeBase>.jpg (ou .png etc.)
    public static byte[] carregarCapaInicial(String nomeBase) {

        for (String extensao : EXTENSOES) {

            try (InputStream entrada = ImagemUtil.class.getResourceAsStream("/capas-iniciais/" + nomeBase + extensao)) {

                if (entrada != null) {

                    byte[] bytes = lerBytes(entrada, LIMITE_BYTES);

                    if (bytes == null) {
                        System.out.println("Capa inicial ignorada (maior que 2 MB): " + nomeBase + extensao);
                    }

                    return bytes;
                }

            } catch (IOException e) {

                System.out.println("Erro ao ler a capa inicial " + nomeBase + extensao + ": " + e.getMessage());

            }
        }

        return null;
    }
}
package br.com.lexxis.util;

import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;

public class SenhaUtil {

    private static final int ITERACOES = 65536;
    private static final int TAMANHO_HASH = 256;

    // Transforma "123456" em algo como "65536:Zm9v...:YmFy..."
    public static String gerarHash(String senha) {

        try {

            byte[] salt = new byte[16];
            new SecureRandom().nextBytes(salt);

            byte[] hash = pbkdf2(senha, salt, ITERACOES);

            return ITERACOES + ":"
                    + Base64.getEncoder().encodeToString(salt) + ":"
                    + Base64.getEncoder().encodeToString(hash);

        } catch (Exception e) {

            throw new RuntimeException("Erro ao gerar o hash da senha", e);

        }
    }

    // Confere se a senha digitada corresponde ao hash que está no banco
    public static boolean conferir(String senha, String hashSalvo) {

        try {

            String[] partes = hashSalvo.split(":");

            int iteracoes = Integer.parseInt(partes[0]);
            byte[] salt = Base64.getDecoder().decode(partes[1]);
            byte[] esperado = Base64.getDecoder().decode(partes[2]);

            byte[] calculado = pbkdf2(senha, salt, iteracoes);

            return MessageDigest.isEqual(esperado, calculado);

        } catch (Exception e) {

            return false;

        }
    }

    private static byte[] pbkdf2(String senha, byte[] salt, int iteracoes) throws Exception {

        PBEKeySpec spec = new PBEKeySpec(senha.toCharArray(), salt, iteracoes, TAMANHO_HASH);

        return SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256")
                .generateSecret(spec)
                .getEncoded();
    }
}
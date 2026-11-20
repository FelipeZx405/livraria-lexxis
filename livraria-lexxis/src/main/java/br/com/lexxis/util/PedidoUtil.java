package br.com.lexxis.util;

import java.util.Arrays;
import java.util.Calendar;
import java.util.List;

public class PedidoUtil {

    public static final double FRETE_FIXO = 15.90;
    public static final double FRETE_GRATIS_ACIMA = 150.00;
    public static final double DESCONTO_PIX = 0.05;   // 5%
    public static final int MAX_PARCELAS = 6;
    public static final double PARCELA_MINIMA = 20.00;

    private static final List<String> UFS = Arrays.asList(
            "AC", "AL", "AP", "AM", "BA", "CE", "DF", "ES", "GO", "MA", "MT", "MS", "MG", "PA",
            "PB", "PR", "PE", "PI", "RJ", "RN", "RS", "RO", "RR", "SC", "SP", "SE", "TO");

    public static double arredondar(double valor) {
        return Math.round(valor * 100.0) / 100.0;
    }

    public static double calcularFrete(double subtotal) {
        return subtotal >= FRETE_GRATIS_ACIMA ? 0 : FRETE_FIXO;
    }

    public static double calcularDesconto(String forma, double subtotal) {
        if ("PIX".equals(forma)) {
            return arredondar(subtotal * DESCONTO_PIX);
        }
        return 0;
    }

    public static int maxParcelas(double total) {
        int n = (int) Math.floor(total / PARCELA_MINIMA);
        return Math.max(1, Math.min(MAX_PARCELAS, n));
    }

    public static String soDigitos(String texto) {
        if (texto == null) {
            return "";
        }
        return texto.replaceAll("\\D", "");
    }

    public static boolean ufValida(String uf) {
        return uf != null && UFS.contains(uf);
    }

    // algoritmo de Luhn (confere se o número do cartão é plausível)
    public static boolean cartaoValido(String numero) {

        if (numero == null || numero.length() < 13 || numero.length() > 19) {
            return false;
        }

        int soma = 0;
        boolean dobrar = false;

        for (int i = numero.length() - 1; i >= 0; i--) {

            int d = numero.charAt(i) - '0';

            if (d < 0 || d > 9) {
                return false;
            }

            if (dobrar) {
                d *= 2;
                if (d > 9) {
                    d -= 9;
                }
            }

            soma += d;
            dobrar = !dobrar;
        }

        return soma % 10 == 0;
    }

    // validade no formato MM/AA; o cartão vale até o fim do mês informado
    public static boolean validadeValida(String validade) {

        if (validade == null || !validade.matches("(0[1-9]|1[0-2])/\\d{2}")) {
            return false;
        }

        int mes = Integer.parseInt(validade.substring(0, 2));
        int ano = 2000 + Integer.parseInt(validade.substring(3, 5));

        Calendar agora = Calendar.getInstance();
        int anoAtual = agora.get(Calendar.YEAR);
        int mesAtual = agora.get(Calendar.MONTH) + 1;

        return ano > anoAtual || (ano == anoAtual && mes >= mesAtual);
    }
}
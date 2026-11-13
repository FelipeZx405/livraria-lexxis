package br.com.lexxis.filter;

import br.com.lexxis.model.Usuario;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    private static final Object[][] LIVROS_INICIAIS = {
            {"Dom Casmurro", "Machado de Assis",
                    "Clássico da literatura brasileira em que Bentinho relembra o amor por Capitu e as dúvidas que marcaram sua vida.",
                    39.90, 15, "dom-casmurro.jpg"},
            {"1984", "George Orwell",
                    "Distopia sobre um regime totalitário que vigia e controla tudo, até o pensamento de seus cidadãos.",
                    49.90, 20, "1984.jpg"},
            {"O Pequeno Príncipe", "Antoine de Saint-Exupéry",
                    "Fábula de um pequeno príncipe que viaja entre planetas e fala de amizade, amor e do que realmente importa.",
                    29.90, 30, "pequeno-principe.jpg"},
            {"Harry Potter e a Pedra Filosofal", "J.K. Rowling",
                    "Aos onze anos, Harry descobre que é bruxo e começa sua jornada na Escola de Magia e Bruxaria de Hogwarts.",
                    59.90, 12, "harry-potter.jpg"}
    };

    // páginas que SÓ o administrador pode abrir
    private static final String[] ROTAS_ADMIN = {
            "/index.jsp",
            "/form-livro",
            "/dashboard.jsp",
            "/find-all-livros",
            "/create-livro",
            "/delete-livro",
            "/dashboard-usuarios.jsp",
            "/find-all-usuarios",
            "/create-usuario",
            "/delete-usuario",
            "/console"
    };

    @Override
    public void init(FilterConfig filterConfig) {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String path = req.getRequestURI().substring(req.getContextPath().length());

        HttpSession session = req.getSession(false);
        Usuario usuario = session == null ? null : (Usuario) session.getAttribute("usuarioLogado");
        boolean logado = usuario != null;

        // quem abre o site (endereço "/") vai direto para a Home
        if (path.isEmpty() || path.equals("/")) {
            resp.sendRedirect("/home");
            return;
        }

        boolean paginaPublica = path.equals("/login")
                || path.equals("/registro")
                || path.equals("/home")
                || path.equals("/catalogo")
                || path.startsWith("/css/")
                || path.startsWith("/img/");

        if (paginaPublica) {
            chain.doFilter(request, response);
            return;
        }

        // daqui para baixo, só quem está logado
        if (!logado) {
            if (path.equals("/carrinho")) {
                resp.sendRedirect("/login?aviso=carrinho");
            } else {
                resp.sendRedirect("/login");
            }
            return;
        }

        // rotas do administrador
        if (ehRotaAdmin(path) && !usuario.isAdmin()) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Acesso restrito ao administrador");
            return;
        }

        chain.doFilter(request, response);

    }

    private boolean ehRotaAdmin(String path) {

        String caminho = path.toLowerCase();

        for (String rota : ROTAS_ADMIN) {
            if (caminho.equals(rota) || caminho.startsWith(rota + "/")) {
                return true;
            }
        }

        return false;
    }

    @Override
    public void destroy() {
    }
}
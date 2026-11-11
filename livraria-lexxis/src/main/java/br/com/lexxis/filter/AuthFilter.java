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

        // quem abre o site (endereço "/") vai direto para o catálogo
        if (path.isEmpty() || path.equals("/")) {
            resp.sendRedirect(logado && usuario.isAdmin() ? "/find-all-livros" : "/catalogo");
            return;
        }

        boolean paginaPublica = path.equals("/login")
                || path.equals("/registro")
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
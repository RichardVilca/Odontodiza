package com.proyecto.odontodiza.controller;

import com.proyecto.odontodiza.dao.OdontologoDAO;
import com.proyecto.odontodiza.model.Odontologo;
import com.proyecto.odontodiza.dao.UsuarioDAO;
import com.proyecto.odontodiza.model.Usuario;
import com.proyecto.odontodiza.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UsuarioDAO usuarioDAO;
    private OdontologoDAO odontologoDAO;

    @Override
    public void init() {
        usuarioDAO = new UsuarioDAO();
        odontologoDAO = new OdontologoDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        Usuario usuario = usuarioDAO.findByEmail(email);

        if (usuario != null && PasswordUtil.checkPassword(password, usuario.getContrasena())) {
            // Autenticación exitosa
            HttpSession session = request.getSession();
            session.setAttribute("usuario", usuario);
            System.out.println("LoginServlet: User " + usuario.getNombreUsuario() + " logged in. Session ID: " + session.getId());

            // Redirigir según el rol
            if ("Odontologo".equalsIgnoreCase(usuario.getRol())) {
                Odontologo odontologo = odontologoDAO.findByUsuarioId(usuario.getId());
                session.setAttribute("odontologo", odontologo);
                response.sendRedirect(request.getContextPath() + "/odontologo"); // Futura página del odontólogo
            }
            else if ("Paciente".equalsIgnoreCase(usuario.getRol())) {
                response.sendRedirect(request.getContextPath() + "/paciente"); // Futura página del paciente
            }
        } else {
            // Autenticación fallida
            request.setAttribute("error", "Correo electrónico o contraseña incorrectos.");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        }
    }
}

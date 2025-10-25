package com.proyecto.odontodiza.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.nio.charset.StandardCharsets;
import java.math.BigInteger;

public class PasswordUtil {

    /**
     * Hashea una contraseña usando el algoritmo SHA-256.
     * @param password La contraseña en texto plano.
     * @return El hash de la contraseña como un string hexadecimal de 64 caracteres.
     */
    public static String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes(StandardCharsets.UTF_8));
            BigInteger number = new BigInteger(1, hash);
            StringBuilder hexString = new StringBuilder(number.toString(16));

            // Asegurarse de que el hash tenga 64 caracteres
            while (hexString.length() < 64) {
                hexString.insert(0, '0');
            }

            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error al hashear la contraseña", e);
        }
    }

    /**
     * Compara una contraseña en texto plano con un hash existente.
     * @param plainPassword La contraseña en texto plano introducida por el usuario.
     * @param hashedPassword El hash almacenado en la base de datos.
     * @return true si las contraseñas coinciden, false en caso contrario.
     */
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        String hashOfPlainPassword = hashPassword(plainPassword);
        return hashOfPlainPassword.equals(hashedPassword);
    }
}

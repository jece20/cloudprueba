package com.empresa.chatbot.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.empresa.chatbot.model.ConsultaEstadoRequest;
import com.empresa.chatbot.repository.DispositivoRepository;

@Service
public class ChatbotService {

    @Autowired
    private DispositivoRepository dispositivoRepository;

    public String consultarEstado(ConsultaEstadoRequest request) {
        // Lógica para consultar el estado del equipo
        return dispositivoRepository.findEstadoById(request.getIdEquipo());
    }
}
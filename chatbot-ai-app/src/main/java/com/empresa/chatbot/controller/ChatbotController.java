package com.empresa.chatbot.controller;

import com.empresa.chatbot.model.ConsultaEstadoRequest;
import com.empresa.chatbot.service.ChatbotService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/chatbot")
public class ChatbotController {

    @Autowired
    private ChatbotService chatbotService;

    @PostMapping("/consultaEstado")
    public ResponseEntity<String> consultarEstado(@RequestBody ConsultaEstadoRequest request) {
        String estado = chatbotService.obtenerEstadoEquipo(request.getIdEquipo());
        return ResponseEntity.ok(estado);
    }
}
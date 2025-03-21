package com.example.anhk.model.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "answer_option")
public class AnswerOption extends StandartEntityId {

    @Column(name = "answer_text", nullable = false, length = Integer.MAX_VALUE)
    private String answerText;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "question_id", nullable = false)
    private QuestionOption question;

}
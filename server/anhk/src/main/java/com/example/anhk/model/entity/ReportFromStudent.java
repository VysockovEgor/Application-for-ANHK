package com.example.anhk.model.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "report_from_student")
public class ReportFromStudent extends StandartEntityId {

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "practice_id", nullable = false)
    private Practice practice;

    @OneToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "ANKETA_ID",unique = true)
    private Anketa anketa;

}
package com.tdk.randmeth.campaigns.model

import java.util.*
import javax.persistence.*

@Entity
class Campaign(
        var title: String,
        var summary: String,
        var description: String,
        var date: Date,
        var owner: String,
        @Embedded var venue: Address,
        @Id @GeneratedValue var id: Long? = null
)

//@Access(AccessType.FIELD)
//class  Place ( address: Address)

@Embeddable
class Address(val city: String, val surbub: String, val geo: String)

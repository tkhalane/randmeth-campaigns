package com.tdk.randmeth.campaigns.config

import com.tdk.randmeth.campaigns.model.Address
import com.tdk.randmeth.campaigns.model.Campaign
import com.tdk.randmeth.campaigns.repository.CampaignRepository
import org.springframework.boot.ApplicationRunner
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import java.util.*

@Configuration
class CampaignsDataInitializer {
    @Bean
    fun databaseInitializer(campaignsRepository: CampaignRepository) = ApplicationRunner {
        val address = Address(city = "Johannesburg", surbub = "Ranburg", geo = "12 Kent Street, Randuarg, Johannesburg: 01.2132131 13213");
        campaignsRepository.save(
                Campaign(
                        title = "SERVICE OF APPRECIATION ON",
                        summary = "SERVICE OF APPRECIATION ON by Rev Donald Cragg",
                        description = "Rev Donald Cragg who has served this church and surrounding communities\n" +
                                "for many years is moving to Edenvale and we will be having a tea after the\n" +
                                "09h30 service on the 24th March in his honour. All are invited to attend.",
                        date = Date(),
                        owner = "Rev Donald Cragg",
                        venue = address
                )
        )
        campaignsRepository.save(
                Campaign(
                        title = "Fund raising",
                        summary = "Manyano raising funds for Orphanage",
                        description = "On the 4th of July to 12th of August, the Manyano will be going door to door trying to raise as much money as possible for Randburg orphanage.",
                        date = Date(),
                        owner = "witness@randmeth.co.za",
                        venue = address
                )
        )
        campaignsRepository.save(
                Campaign(
                        title = "OUTREACH TRAINING",
                        summary = "OUTREACH TRAINING",
                        description = "We will be having outreach training on the 6th April from 10h00 onwards.\n" +
                                "This will be in preparation for the Saint Stithians outreach on the 20th April",
                        date = Date(),
                        owner = "witness@randmeth.co.za",
                        venue = address
                )
        )

        campaignsRepository.save(
                Campaign(
                        title = "DONATION OF SANITARY",
                        summary = "DONATION OF SANITARY",
                        description = "The Young Woman’s Manyano are doing Outreach on the 6th April and are asking for a donations from the Congregation of\n" +
                                "the Sanitary products. Please could you assist this worthwhile cause? Please mark the packets Sanitary Products or\n" +
                                "Young Woman’s Manyano",
                        date = Date(),
                        owner = "witness@randmeth.co.za",
                        venue = address
                )
        )
        campaignsRepository.save(
                Campaign(
                        title = "Fund raising",
                        summary = "Manyano raising funds for Orphanage",
                        description = "On the 4th of July to 12th of August, the Manyano will be going door to door trying to raise as much money as possible for Randburg orphanage.",
                        date = Date(),
                        owner = "witness@randmeth.co.za",
                        venue = address
                )
        )
    }
}


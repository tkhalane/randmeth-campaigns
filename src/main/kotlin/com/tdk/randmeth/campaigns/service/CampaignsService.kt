package com.tdk.randmeth.campaigns.service

import com.tdk.randmeth.campaigns.model.Campaign
import com.tdk.randmeth.campaigns.repository.CampaignRepository
import org.springframework.stereotype.Service

@Service
class CampaignsService(private val campaignsRepository: CampaignRepository) {
    fun getAllCampaigns(): Iterable<Campaign> = campaignsRepository.findAll()
}
package com.tdk.randmeth.campaigns.repository

import com.tdk.randmeth.campaigns.model.Campaign
import org.springframework.data.repository.CrudRepository

interface CampaignRepository : CrudRepository<Campaign, Long>
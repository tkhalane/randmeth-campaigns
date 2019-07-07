package com.tdk.randmeth.campaigns.rest

import com.tdk.randmeth.campaigns.service.CampaignsService
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping("/api/v1/campaigns")
class CampaignsController(val campaignsService: CampaignsService) {
    @GetMapping("")
    fun findAllCampaigns() = campaignsService.getAllCampaigns()
}
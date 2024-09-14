package br.com.rtakahashi.playground.flutter_reference.core.data.service

import br.com.rtakahashi.playground.flutter_reference.core.data.service.infra.InteropService

class StepUpPromptService : InteropService("step-up") {
    /**
     * Shows a step-up authentication prompt to the user. Upon successful authentication, a
     * token is returned from this function. In case of any failure, including dismissal by the
     * user, null is returned.
     */
    suspend fun showStepUpPrompt(sessionId: String): String? {
        return super.call("showStepUpPrompt", sessionId) as? String?
    }
}
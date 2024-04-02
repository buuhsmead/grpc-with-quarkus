package org.acme.probes;



import jakarta.enterprise.context.ApplicationScoped;
import org.eclipse.microprofile.health.HealthCheck;
import org.eclipse.microprofile.health.HealthCheckResponse;
import org.eclipse.microprofile.health.Startup;


// curl localhost:8080/q/health/started

@Startup
@ApplicationScoped
public class CustomStartupProbe implements HealthCheck {

    @Override
    public HealthCheckResponse call() {
        return HealthCheckResponse.up("Startup health check");
    }
}

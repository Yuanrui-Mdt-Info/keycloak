FROM quay.io/keycloak/keycloak:26.4.7 AS builder

ENV KC_HEALTH_ENABLED=true
ENV KC_FEATURES=token-exchange,admin-fine-grained-authz
ENV KC_DB=postgres
ENV KC_HTTP_RELATIVE_PATH="/auth"

# Install custom providers

# Apple Social Identity Provider - https://github.com/klausbetz/apple-identity-provider-keycloak
ADD --chown=keycloak:keycloak ./providers/apple-identity-provider-1.16.0.jar /opt/keycloak/providers/apple-identity-provider-1.16.0.jar

# build optimized image
RUN /opt/keycloak/bin/kc.sh build 

FROM quay.io/keycloak/keycloak:26.4.7

COPY --from=builder /opt/keycloak/ /opt/keycloak/
WORKDIR /opt/keycloak

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]

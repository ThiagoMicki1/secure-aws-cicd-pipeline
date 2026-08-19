from app import create_app


def test_health_endpoint_returns_ok():
    client = create_app().test_client()

    response = client.get("/health")

    assert response.status_code == 200
    assert response.get_json() == {"status": "ok"}


def test_homepage_explains_safe_mode():
    client = create_app().test_client()

    response = client.get("/")
    data = response.get_json()

    assert response.status_code == 200
    assert data["project"] == "secure-aws-cicd-pipeline"
    assert data["mode"] == "safe portfolio mode"


def test_security_controls_are_listed():
    client = create_app().test_client()

    response = client.get("/security-controls")
    controls = response.get_json()["controls"]

    assert response.status_code == 200
    assert "Gitleaks secrets scanning" in controls
    assert "Manual-only AWS deployment using GitHub OIDC" in controls

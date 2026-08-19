from flask import Flask, jsonify


SECURITY_CONTROLS = [
    "GitHub Actions least-privilege workflow permissions",
    "Gitleaks secrets scanning",
    "Semgrep static application security testing",
    "Trivy container vulnerability scanning",
    "Checkov infrastructure-as-code scanning",
    "Terraform validation without automatic deployment",
    "Manual-only AWS deployment using GitHub OIDC",
]


def create_app() -> Flask:
    app = Flask(__name__)

    @app.get("/")
    def index():
        return jsonify(
            {
                "project": "secure-aws-cicd-pipeline",
                "mode": "safe portfolio mode",
                "message": "This demo validates a secure CI/CD pipeline without deploying to AWS by default.",
            }
        )

    @app.get("/health")
    def health():
        return jsonify({"status": "ok"})

    @app.get("/ready")
    def ready():
        return jsonify({"ready": True})

    @app.get("/security-controls")
    def security_controls():
        return jsonify({"controls": SECURITY_CONTROLS})

    return app


app = create_app()

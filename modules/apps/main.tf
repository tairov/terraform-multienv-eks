resource "helm_release" "redis" {
  count            = var.apps.redis.enabled == true ? 1 : 0
  name             = "redis"
  namespace        = "redis-${var.env}"
  create_namespace = true
  chart            = "redis"
  repository       = "oci://registry-1.docker.io/bitnamicharts"
  version          = "17.11.3"
  set {
    name  = "auth.enabled"
    value = false
  }
  set {
    name  = "auth.password"
    value = ""
  }
  set {
    name  = "replica.replicaCount"
    value = "0"
  }
  timeout = 1800
}

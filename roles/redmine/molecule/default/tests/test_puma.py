def test_puma_running_and_enabled(host):
    puma = host.service("puma")
    assert puma.is_running
    assert puma.is_enabled

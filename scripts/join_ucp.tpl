docker image pull docker/ucp-agent-win:${ucp_version};
docker image pull docker/ucp-dsinfo-win:${ucp_version};

# Setup certificate and service
mkdir C:\ProgramData\docker\daemoncerts;
docker container run --rm -v C:\ProgramData\docker\daemoncerts:C:\certs docker/ucp-agent-win:${ucp_version} generate-certs;

Write-Host "Restarting Docker daemon";
Stop-Service docker;
dockerd --unregister-service;
dockerd -H npipe:// -H 0.0.0.0:2376 --tlsverify --tlscacert=C:\ProgramData\docker\daemoncerts\ca.pem --tlscert=C:\ProgramData\docker\daemoncerts\cert.pem --tlskey=C:\ProgramData\docker\daemoncerts\key.pem --register-service
Start-Service docker;
Write-Host "Successfully set up Docker daemon";

# Open ports in the Windows firewall
netsh advfirewall firewall add rule name="docker_local" dir=in action=allow protocol=TCP localport=2376
netsh advfirewall firewall add rule name="docker_proxy" dir=in action=allow protocol=TCP localport=12376

Write-Host "Opening port 2376 in the Windows firewall for inbound traffic";
netsh advfirewall firewall add rule name="docker_2376_in" dir=in action=allow protocol=TCP localport=2376 | Out-Null;

Write-Host "Opening port 12376 in the Windows firewall for inbound traffic";
netsh advfirewall firewall add rule name="docker_12376_in" dir=in action=allow protocol=TCP localport=12376 | Out-Null;

Write-Host "Opening port 2377 in the Windows firewall for inbound traffic";
netsh advfirewall firewall add rule name="docker_2377_in" dir=in action=allow protocol=TCP localport=2377 | Out-Null;

Write-Host "Opening port 7946 in the Windows firewall for inbound and outbound traffic";
netsh advfirewall firewall add rule name="docker_7946_in" dir=in action=allow protocol=TCP localport=7946 | Out-Null;
netsh advfirewall firewall add rule name="docker_7946_out" dir=out action=allow protocol=TCP localport=7946 | Out-Null;

Write-Host "Opening UDP port 4789 in the Windows firewall for inbound and outbound traffic";
netsh advfirewall firewall add rule name="docker_4789_udp_in" dir=in action=allow protocol=UDP localport=4789 | Out-Null;
netsh advfirewall firewall add rule name="docker_4789_udp_out" dir=out action=allow protocol=UDP localport=4789 | Out-Null;

Write-Host "Opening UDP port 7946 in the Windows firewall for inbound and outbound traffic";
netsh advfirewall firewall add rule name="docker_7946_udp_in" dir=in action=allow protocol=UDP localport=7946 | Out-Null;
netsh advfirewall firewall add rule name="docker_7946_udp_out" dir=out action=allow protocol=UDP localport=7946 | Out-Null;

# Join worker

$Username="admin";
$Password="P@ssw0rd";
$Body = "{`"username`":`"$($Username)`", `"password`":`"$($Password)`"}";


add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@

[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$AUTH_TOKEN=((Invoke-WebRequest -UseBasicParsing -Body $Body -Uri "https://${manager_dns}/auth/login" -Method POST).Content) | ConvertFrom-Json |select auth_token -ExpandProperty auth_token;

$WORKER_TOKEN=((Invoke-WebRequest -UseBasicParsing -Headers @{"Authorization"="Bearer $AUTH_TOKEN"} -Uri "https://${manager_dns}/swarm").Content) | ConvertFrom-Json |Select JoinTokens -ExpandProperty JoinTokens | Select Worker -ExpandProperty Worker;

docker swarm join --token $WORKER_TOKEN ${manager_ip}:2377
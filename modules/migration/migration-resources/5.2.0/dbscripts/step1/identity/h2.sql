ALTER TABLE IDN_OAUTH_CONSUMER_APPS ADD COLUMN PKCE_MANDATORY CHAR(1) DEFAULT '0';
ALTER TABLE IDN_OAUTH_CONSUMER_APPS ADD COLUMN PKCE_SUPPORT_PLAIN CHAR(1) DEFAULT '0';

ALTER TABLE IDN_OAUTH2_AUTHORIZATION_CODE ADD COLUMN PKCE_CODE_CHALLENGE VARCHAR(255);
ALTER TABLE IDN_OAUTH2_AUTHORIZATION_CODE ADD COLUMN PKCE_CODE_CHALLENGE_METHOD VARCHAR(128);

ALTER TABLE WF_BPS_PROFILE ALTER COLUMN HOST_URL_MANAGER VARCHAR(255);
ALTER TABLE WF_BPS_PROFILE ALTER COLUMN HOST_URL_WORKER VARCHAR(255);

INSERT INTO IDP_AUTHENTICATOR (TENANT_ID, IDP_ID, NAME, IS_ENABLED)
  SELECT TENANT_ID, IDP_ID, 'openidconnect', 0
  FROM IDP_AUTHENTICATOR
  WHERE IDP_ID
  IN (SELECT ID FROM IDP WHERE NAME = 'LOCAL')
  GROUP BY TENANT_ID, IDP_ID
  HAVING SUM(CASE NAME WHEN 'openidconnect' THEN 1 ELSE 0 END)=0;

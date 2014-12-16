# Encoding: utf-8

class QubellError < StandardError
end

class AuthenticationError < QubellError
end

class DestroyError < QubellError
end

class PermissionsError < QubellError
end

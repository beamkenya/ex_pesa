defmodule ExPesa.Jenga.Signature do

  @moduledoc """
  ## signatures

  To ensure the security of your transactions or requests, we have implemented security controls that we ensure that transactions can only be initiated by you and no one else. To achieve this, we use message signatures.
  How it works

  All requests, other than the Identity API, will be required to have a signature in the header. The structure of the header will be as follows:

  ## generate signature:

  To generate the signature, you will need create a key pair of private key and public key. You will share the public key with us and use the private key to generate the signature.
  Creating private & public keys

  Use following command in command prompt to generate a keypair with a self-signed certificate.

  In this command, we are using the openssl. You can use other tools e.g. keytool (ships with JDK - Java Developement Kit), keystore explorer e.t.c
  ## GENERATE YOUR KEY PAIR
  openssl genrsa -out privatekey.pem 2048 -nodes

  Once you are successful with the above command a file (privatekey.pem) will be created on your present directory, proceed to export the public key from the keypair generated. The command below shows how to do it.

  ## NOW EXPORT YOUR PUBLIC KEY
  openssl rsa -in privatekey.pem -outform PEM -pubout -out publickey.pem

  If the above command is successful, a new file (publickey.pem) will be created on your present directory. Copy the contents of this file and add it on our jengaHQ portal.
  """

  @doc """
  read more on https://developer.jengaapi.io/docs/generating-signatures
  Example
    ExPesa.Jenga.Signature.sign_transaction(%{country_code: "KE", account_id: "0011547896523"})
    "jCUM84oReyyWfwSM2/EGoMUnJLXSRZ8YR7mS7VaUv3KIsYR4o3r/hoSENhQw9Z3BsWAxvKQoZX+VNrLyEmoIK2lUyE0vqUd9IN2RDZYr4rWzuXwmjsM5eq+ALRd8pDRGmwIPTA17y7MCeJhY6jmLjXUghaziWzo5ViJS1QdPvvxDiiOip2HxjPtVN9dsPIoc9i/mzAzAJssauvgVRzz2w6DQwg6bZIeDOcroRVqMBkBk2IcGHK6PSWWftaVSFL/2pbHNZyIMytI9qYpPHolLoPK2uKqftQXP8GNHUwasmsMmEBtYQ3mqC2fsb+YPGHLam8KEZ/FvS63GfQGJ+YivYA=="
  """
  def sign_transaction(%{
        country_code: country_code,
        account_id: account_id
      }) do
        today = NaiveDateTime.add(NaiveDateTime.utc_now(), (3600 * 3))
        date = [today.year, today.month, today.day]
              |> Enum.map(&to_string/1)
              |> Enum.map(&String.pad_leading(&1, 2, "0"))
              |> Enum.join("-")
        message = "#{account_id}#{country_code}#{date}"
        sign(message)
  end

  def sign(message) do
    raw_secret_key = Application.get_env(:ex_pesa, :jenga)[:private_key]

    # Cleaning blank spaces
    secret_key =
      raw_secret_key
      |> String.trim()
      |> String.split(~r{\n  *}, trim: true)
      |> Enum.join("\n")

    [pem_entry] = :public_key.pem_decode(secret_key)

    private_key = :public_key.pem_entry_decode(pem_entry)

    signature = :public_key.sign(message, :sha256, private_key)

    :base64.encode(signature)
  end

end

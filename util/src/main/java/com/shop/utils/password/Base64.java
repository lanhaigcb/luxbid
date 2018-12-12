package com.shop.utils.password;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStream;

public class Base64 {
	protected static byte[] encode(byte abyte0[]) {
		int i = ((abyte0.length + 2) / 3) * 4;
		ByteArrayOutputStream bytearrayoutputstream = new ByteArrayOutputStream(
				i);
		try {
			encoder.encode(abyte0, 0, abyte0.length, bytearrayoutputstream);
		} catch (IOException ioexception) {
			throw new RuntimeException((new StringBuilder()).append(
					"exception encoding base64 string: ").append(ioexception)
					.toString());
		}
		return bytearrayoutputstream.toByteArray();
	}

	protected static int encode(byte abyte0[], OutputStream outputstream)
			throws IOException {
		return encoder.encode(abyte0, 0, abyte0.length, outputstream);
	}

	protected static int encode(byte abyte0[], int i, int j,
			OutputStream outputstream) throws IOException {
		return encoder.encode(abyte0, i, j, outputstream);
	}

	protected static byte[] decode(byte abyte0[]) {
		int i = (abyte0.length / 4) * 3;
		ByteArrayOutputStream bytearrayoutputstream = new ByteArrayOutputStream(
				i);
		try {
			encoder.decode(abyte0, 0, abyte0.length, bytearrayoutputstream);
		} catch (IOException ioexception) {
			throw new RuntimeException((new StringBuilder()).append(
					"exception decoding base64 string: ").append(ioexception)
					.toString());
		}
		return bytearrayoutputstream.toByteArray();
	}

	protected static byte[] decode(String s) {
		int i = (s.length() / 4) * 3;
		ByteArrayOutputStream bytearrayoutputstream = new ByteArrayOutputStream(
				i);
		try {
			encoder.decode(s, bytearrayoutputstream);
		} catch (IOException ioexception) {
			throw new RuntimeException((new StringBuilder()).append(
					"exception decoding base64 string: ").append(ioexception)
					.toString());
		}
		return bytearrayoutputstream.toByteArray();
	}

	protected static int decode(String s, OutputStream outputstream)
			throws IOException {
		return encoder.decode(s, outputstream);
	}

	private static final Encoder encoder = new Base64Encoder();

}
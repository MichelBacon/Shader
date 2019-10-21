Shader "Custom/Test" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_ScrollSpeed("Scroll speed", Range(0,100)) = 10
	}
	SubShader {
		Tags { "Queue" = "Transparent" "RenderType"="Transparent" }
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows alpha:fade

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;
		half _ScrollSpeed;

		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input IN, inout SurfaceOutputStandard o) {
			// Albedo comes from a texture tinted by color
			fixed2 scrolledUV = IN.uv_MainTex;
			fixed scrollValue = _Time * _ScrollSpeed;
			scrolledUV += fixed2(scrollValue, 0);
			scrollValue = _Time * _ScrollSpeed/3;
			fixed2 scrolledUV2 = IN.uv_MainTex + fixed2(scrollValue,0);
			fixed4 c = tex2D(_MainTex, scrolledUV) * tex2D(_MainTex, scrolledUV2) * _Color;
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = c.rgb;
		}
		ENDCG
	}
	FallBack "Diffuse"
}

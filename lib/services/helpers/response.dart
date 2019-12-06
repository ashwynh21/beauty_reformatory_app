class Response {
    dynamic debug;
    String message;
    dynamic payload;
    bool result;
    int status;

    Response({this.debug, this.message, this.payload, this.result, this.status});

    factory Response.fromJson(Map<String, dynamic> json) {
        return Response(
            debug: json['debug'],
            message: json['message'],
            payload: json['payload'],
            result: json['result'],
            status: json['status'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['debug'] = this.debug;
        data['message'] = this.message;
        data['payload'] = this.payload;
        data['result'] = this.result;
        data['status'] = this.status;
        return data;
    }
}
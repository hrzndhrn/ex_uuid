defmodule ExUUID.ImplTest do
  use ExUnit.Case

  alias ExUUID.Impl

  @clock_sequence <<253, 14::size(6)>>
  @node_id <<236, 244, 236, 23, 17, 187>>
  @timestamp <<30, 181, 107, 83, 231, 63, 72, 8::size(4)>>
  @hash <<69, 161, 19, 172, 199, 242, 0, 176, 208, 165, 163, 153, 171, 145, 39, 22>>

  describe "uuid/5" do
    test "creates version 1 uuid" do
      assert Impl.uuid(:v1, @timestamp, @clock_sequence, @node_id, :default) ==
               "3e73f488-56b5-11eb-bf4e-ecf4ec1711bb"

      assert Impl.uuid(:v1, @timestamp, @clock_sequence, @node_id, :hex) ==
               "3e73f48856b511ebbf4eecf4ec1711bb"

      assert Impl.uuid(:v1, @timestamp, @clock_sequence, @node_id, :binary) ==
               <<62, 115, 244, 136, 86, 181, 17, 235, 191, 78, 236, 244, 236, 23, 17, 187>>
    end

    test "creates version 6 uuid" do
      assert Impl.uuid(:v6, @timestamp, @clock_sequence, @node_id, :default) ==
               "1eb56b53-e73f-6488-bf4e-ecf4ec1711bb"

      assert Impl.uuid(:v6, @timestamp, @clock_sequence, @node_id, :hex) ==
               "1eb56b53e73f6488bf4eecf4ec1711bb"

      assert Impl.uuid(:v6, @timestamp, @clock_sequence, @node_id, :binary) ==
               <<30, 181, 107, 83, 231, 63, 100, 136, 191, 78, 236, 244, 236, 23, 17, 187>>
    end
  end

  describe "uuid/3" do
    test "creates version 3 uuid" do
      assert Impl.uuid(:v3, @hash, :default) == "45a113ac-c7f2-30b0-90a5-a399ab912716"
      assert Impl.uuid(:v3, @hash, :hex) == "45a113acc7f230b090a5a399ab912716"

      assert Impl.uuid(:v3, @hash, :binary) ==
               <<69, 161, 19, 172, 199, 242, 48, 176, 144, 165, 163, 153, 171, 145, 39, 22>>
    end

    test "creates version 4 uuid" do
      assert Impl.uuid(:v4, @hash, :default) == "45a113ac-c7f2-40b0-90a5-a399ab912716"
      assert Impl.uuid(:v4, @hash, :hex) == "45a113acc7f240b090a5a399ab912716"

      assert Impl.uuid(:v4, @hash, :binary) ==
               <<69, 161, 19, 172, 199, 242, 64, 176, 144, 165, 163, 153, 171, 145, 39, 22>>
    end

    test "creates version 5 uuid" do
      assert Impl.uuid(:v5, @hash, :default) == "45a113ac-c7f2-50b0-90a5-a399ab912716"
      assert Impl.uuid(:v5, @hash, :hex) == "45a113acc7f250b090a5a399ab912716"

      assert Impl.uuid(:v5, @hash, :binary) ==
               <<69, 161, 19, 172, 199, 242, 80, 176, 144, 165, 163, 153, 171, 145, 39, 22>>
    end
  end
end
